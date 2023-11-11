// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { DecentralizedStableCoin } from "../src/DecentralizedStableCoin.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/// @title CSCEngine (Catella StableCoin Engine)
/// @author Catherine Maverick from catellatech.
/// The system is designed to be as minimal as possible, and have the token mantain 1 Token == $1 peg.
/// This Stablecoin has the properties:
/// - Exogenous Collateral (wBTC - wETH)
/// - Dollar pegged
/// - Algoritmically stable
/// It is similar to DAI if DAI had no governance, no fees, and was only backed by WETH and WBTC.
/// Our CSC system should always be (Overcollateralized). At no point, should the value of all collateral <= the $
/// backed value of all the CSC. (Siempre tenemos que tener mas WBTC O WETH que CSC).
/// @notice This contract is the core of the CSC system. It handles all the logic for minting and redeeming CSC, as well
/// as depositing and withdrawing collateral.
/// @notice This contract is very loosely based on the MakerDAO DSS (DAI) system.

contract CSCEngine is ReentrancyGuard {
    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    ERRORS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    error CSCEngine__NeedsMoreThanZero();
    error CSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
    error CSCEngine__TokenNotAllowed();
    error CSCEngine__TransferFaild();
    error CSCEngine__BreaksHealthFactor(uint256 healthFactor);
    error CSCEngine__MintFaild();

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                STATE VARIABLES 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    uint256 private constant ADDITIONAL_FEED_PRECISION = 1e10;
    uint256 private constant PRECISION = 1e18;
    uint256 private constant LIQUIDATION_THRESHOLD = 50; // 200% Overcollateralized
    uint256 private constant LIQUIDATION_PRECISION = 100;
    uint256 private constant MIN_HEALTH_FACTOR = 1;

    mapping(address token => address priceFeed) private s_priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;
    mapping(address user => uint256 amountCscMinted) private s_CSCMinted;
    address[] s_collateralTokens;

    DecentralizedStableCoin private immutable i_cscToken;

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    EVENTS 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    event CollateralDeposited(address indexed user, address indexed collateralToken, uint256 indexed amount);

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    MODIFIERS 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    modifier moreThanZero(uint256 amount) {
        if (amount == 0) revert CSCEngine__NeedsMoreThanZero();
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) revert CSCEngine__TokenNotAllowed();
        _;
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                FUNCTIONS 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address cscAddress) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert CSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }

        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
            s_collateralTokens.push(tokenAddresses[i]);
        }

        i_cscToken = DecentralizedStableCoin(cscAddress);
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                EXTERNAL FUNCTIONS 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    function depositCollateralAndMintCsc() external { }

    /**
     * @notice Esta función está diseñada para permitir a los usuarios depositar un activo como collateral.
     * @notice Sigue el patrón CEI (Check-Effect-Interation)
     * @param _tokenCollateralAddress Dirección del token que el usuario depositará como collateral (WBTC/WETH)
     * @param _amountCollateral Cantidad de tokens collateral que el usuario depositará.
     */
    function depositCollateral(
        address _tokenCollateralAddress,
        uint256 _amountCollateral
    )
        external
        moreThanZero(_amountCollateral)
        isAllowedToken(_tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][_tokenCollateralAddress] += _amountCollateral;
        emit CollateralDeposited(msg.sender, _tokenCollateralAddress, _amountCollateral);
        bool success = IERC20(_tokenCollateralAddress).transferFrom(msg.sender, address(this), _amountCollateral);
        if (!success) revert CSCEngine__TransferFaild();
    }

    function redeemCollateralForCsc() external { }
    function redeemCollateral() external { }

    /**
     * @notice Esta función permite a los usuarios crear nuevos tokens CSC, siempre y cuando la cantidad sea mayor que
     * cero, se respeten las reglas de no recursividad y Health Factor del usuario esté dentro de ciertos límites.
     * Además, registra el aumento de tokens emitidos y revierte la transacción si la creación de tokens no se
     * realiza con éxito.
     * @notice Sigue el patrón CEI
     * @notice Se debe tener más valor del collateral que el minimo threshold.
     * @param _amountCscToMint La cantidad de tokens CSC que se van a crear o "emitir".
     *
     */
    function mintCsc(uint256 _amountCscToMint) external moreThanZero(_amountCscToMint) nonReentrant {
        s_CSCMinted[msg.sender] += _amountCscToMint;
        _revertIfHealthFactorIsBroken(msg.sender);
        bool minted = i_cscToken.mint(msg.sender, _amountCscToMint);
        if (!minted) revert CSCEngine__MintFaild();
    }

    function burnCsc() external { }
    function liquidate() external { }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                            PRIVATE & INTERNAL FUNCTIONS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    /**
     * @notice Internal function para obtener informacion de una cuenta.
     * @param _user Direccion del usuario.
     * @return totalCscMinted
     * @return collateralValueInUSD
     */

    function _getAccountInformation(address _user)
        internal
        view
        returns (uint256 totalCscMinted, uint256 collateralValueInUSD)
    {
        totalCscMinted = s_CSCMinted[_user];
        collateralValueInUSD = getAccountCollateralValueInUSD(_user);
    }

    /**
     * @notice  Funcion diseñada para calcular un factor de salud financiera (health Factor) de un usuario
     * @notice Si un usuario se va a bajo de 1(MIN_HEALTH_FACTOR), entonces puede ser liquidado.
     * @notice Ajusta el valor del colateral del usuario en función de un umbral de liquidación (Threshold) (utilizado
     * para establecer el límite mínimo aceptable de colateralización).
     * @param _user  La dirección del usuario para la cual se está calculando el factor de salud financiera.
     * @return Calcula y devuelve el factor de salud financiera (Helath Factor). Este cálculo involucra una comparación
     * entre el valor del colateral ajustado y la cantidad total de tokens CSC creados por el usuario.(Retorna que tan
     * cerca de la liquidación está un usuario).
     */
    function _healthFactor(address _user) private view returns (uint256) {
        (uint256 totalCscMinted, uint256 collateralValueInUSD) = _getAccountInformation(_user);
        uint256 collateralAdjustedForThreshold = (collateralValueInUSD * LIQUIDATION_THRESHOLD) / LIQUIDATION_PRECISION;
        return (collateralAdjustedForThreshold * PRECISION) / totalCscMinted;
    }

    /**
     * @notice Función diseñada para verificar si el factor de salud financiera de un usuario cae por debajo de un
     * cierto límite establecido.
     * @param _user  La dirección del usuario para el cual se está verificando el factor de salud financiera.
     */
    function _revertIfHealthFactorIsBroken(address _user) internal view {
        uint256 userHealthFactor = _healthFactor(_user);
        if (userHealthFactor < MIN_HEALTH_FACTOR) revert CSCEngine__BreaksHealthFactor(userHealthFactor);
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                        PUBLIC & EXTERNAL VIEW FUNCTIONS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    /**
     * @notice Esta función tiene la finalidad de calcular el valor total en dólares estadounidenses (USD) de todo el
     * colateral depositado por un usuario
     * @notice Para obtener el valor tenemos que hacer un loop a través de cada (collateral token), obtener el valor
     * que se ha depositado y mapearlo al precio para obtener el valor de USD.
     * @param _user La dirección del usuario para el que se está calculando el valor del colateral en USD.
     * @return totalCollateralValueInUSD Retorna el valor total del colateral del usuario en dólares estadounidenses.
     */
    function getAccountCollateralValueInUSD(address _user) public view returns (uint256 totalCollateralValueInUSD) {
        for (uint256 i = 0; i < s_collateralTokens.length; i++) {
            address token = s_collateralTokens[i];
            uint256 amount = s_collateralDeposited[_user][token];
            totalCollateralValueInUSD += getUsdValue(token, amount);
        }
        return totalCollateralValueInUSD;
    }

    /**
     * @notice Esta función tiene como objetivo calcular el valor en dólares estadounidenses (USD) de una cierta
     * cantidad de un token específico.
     * @param _token La dirección del token del cual se está calculando el valor en USD.
     * @param _amount La cantidad del token para la que se quiere determinar el valor en USD.
     * @notice Se obtiene el precio del token en USD mediante un Price Feed (ChainLink) vinculado a ese token en
     * particular, utilizando la interfaz `AggregatorV3Interface`. Se accede a los datos más recientes del feed de
     * precios para obtener el valor del token en USD.
     * @notice 1 ETH = $1000
     * @notice El valor retornado por el CL será 1000 * 1e8
     */
    function getUsdValue(address _token, uint256 _amount) public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeeds[_token]);
        (, int256 price,,,) = priceFeed.latestRoundData();
        return ((uint256(price) * ADDITIONAL_FEED_PRECISION) * _amount) / PRECISION;
    }

    function getHealthFactor() external view { }
}
