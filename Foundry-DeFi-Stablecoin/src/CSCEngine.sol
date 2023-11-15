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
    error CSCEngine__TransferFailed();
    error CSCEngine__BreaksHealthFactor(uint256 healthFactor);
    error CSCEngine__MintFaild();
    error CSCEngine__HealthFactorOk();
    error CSCEngine__HealthFactorNotImproved();

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                CONSTANT VARIABLES 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    uint256 private constant ADDITIONAL_FEED_PRECISION = 1e10;
    uint256 private constant PRECISION = 1e18;
    uint256 private constant LIQUIDATION_THRESHOLD = 50; // 200% Overcollateralized
    uint256 private constant LIQUIDATION_PRECISION = 100;
    uint256 private constant MIN_HEALTH_FACTOR = 1e18;
    uint256 private constant LIQUIDATION_BONUS = 10; //10% bonus

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                STATE VARIABLES 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    mapping(address token => address priceFeed) private s_priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;
    mapping(address user => uint256 amountCscMinted) private s_CSCMinted;
    address[] s_collateralTokens;

    DecentralizedStableCoin private immutable i_cscToken;

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    EVENTS 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    event CollateralDeposited(address indexed user, address indexed collateralToken, uint256 indexed amount);
    event CollateralRedeemed(
        address indexed redeemedFrom, address indexed redeemedTo, address indexed collateralToken, uint256 amount
    );

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
                                                CONSTRUCTOR 
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

    /**
     * @notice Función diseñada para simplificar y combinar dos acciones relacionadas en una única transacción. en
     * este caso depositCollateral() & mintCsc().
     * @notice Al combinar ambas acciones en una sola función, el objetivo es simplificar el proceso para los usuarios
     * o contratos que deseen realizar estas dos acciones juntas. Esto puede mejorar la eficiencia y reducir el número
     * de transacciones necesarias para lograr el mismo resultado, siempre y cuando ambas acciones estén relacionadas y
     * deban ocurrir al mismo tiempo.
     * @param _tokenCollateralAddress Dirección del token que el usuario depositará como collateral (WBTC/WETH)
     * @param _amountCollateral Cantidad de tokens collateral que el usuario depositará.
     * @param _amountCscToMint La cantidad de tokens CSC que se van a crear o "emitir".
     */
    function depositCollateralAndMintCsc(
        address _tokenCollateralAddress,
        uint256 _amountCollateral,
        uint256 _amountCscToMint
    )
        external
    {
        depositCollateral(_tokenCollateralAddress, _amountCollateral);
        mintCsc(_amountCscToMint);
    }

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
        public
        moreThanZero(_amountCollateral)
        isAllowedToken(_tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][_tokenCollateralAddress] += _amountCollateral;
        emit CollateralDeposited(msg.sender, _tokenCollateralAddress, _amountCollateral);
        bool success = IERC20(_tokenCollateralAddress).transferFrom(msg.sender, address(this), _amountCollateral);
        if (!success) revert CSCEngine__TransferFailed();
    }

    /**
     * @notice Esta función tiene la intención de facilitar la acción combinada de quemar una cantidad específica de
     * la criptomoneda estable (CSC) y, posteriormente, canjear una cantidad correspondiente de colateral. Todo en una
     * sola transacción.
     * @notice La funcion redeemCollateral() ya checkea si el health factor se rompe o no.
     * @param _tokenCollateralAddress Dirección del token que el usuario redimirá como collateral (WBTC/WETH)
     * @param _amountCollateral Cantidad de tokens collateral que el usuario redimirá.
     * @param _amountCscToBurn Cantidad de tokens CSC que se quemarán.
     */
    function redeemCollateralForCsc(
        address _tokenCollateralAddress,
        uint256 _amountCollateral,
        uint256 _amountCscToBurn
    )
        external
    {
        _burnCSC(msg.sender, msg.sender, _amountCscToBurn);
        _redeemCollateral(msg.sender, msg.sender, _tokenCollateralAddress, _amountCollateral);
    }

    /**
     * @notice Función diseñada para permitir a los usuarios retirar o canjear una cantidad específica de colateral
     * de su posición en el sistema.
     * @param _tokeCollateralAddress Dirección del token que el usuario retirará como collateral (WBTC/WETH)
     * @param _amountCollateral Cantidad de tokens collateral que el usuario retirará.
     */
    function redeemCollateral(
        address _tokeCollateralAddress,
        uint256 _amountCollateral
    )
        public
        moreThanZero(_amountCollateral)
        nonReentrant
    {
        _redeemCollateral(msg.sender, msg.sender, _tokeCollateralAddress, _amountCollateral);
        _revertIfHealthFactorIsBroken(msg.sender);
    }

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
    function mintCsc(uint256 _amountCscToMint) public moreThanZero(_amountCscToMint) nonReentrant {
        s_CSCMinted[msg.sender] += _amountCscToMint;
        _revertIfHealthFactorIsBroken(msg.sender);
        bool minted = i_cscToken.mint(msg.sender, _amountCscToMint);
        if (!minted) revert CSCEngine__MintFaild();
    }

    /**
     * @notice Función destinada a permitir que los usuarios "quemen" o reduzcan la cantidad de CSC(StableCoin) que
     * poseen, lo que implica una disminución de la deuda.
     * @param _amount Cantidad de tokens a quemar.
     */
    function burnCsc(uint256 _amount) external moreThanZero(_amount) {
        //Removemos la deuda.
        _burnCSC(msg.sender, msg.sender, _amount);
        _revertIfHealthFactorIsBroken(msg.sender); // No creo que esta linea sea necesaria.
    }

    /**
     * @notice Liquida parcialmente los activos de un usuario.
     * @notice Recibirás una bonificación por la liquidación al adquirir los fondos de los usuarios que han
     * quebrantado su factor de salud.
     * @notice Esta función asume que el protocolo estará aproximadamente undercollateralized en un 200% para que
     * funcione.
     * @notice Un bug conocido podria ser si el protocolo estuviera 100% o menos collateralized. Entonces no podriamos
     * incentivar a los liquidadores.
     * @notice Sigue el patrón CEI: CHECK-EFFECTS-INTERACTIONS.
     * @param _tokenCollateral   La dirección del activo ERC20 usado como colateral a liquidar del usuario.
     * @param _user El usuario que ha roto el health factor. Su _healthFactor() deberia ser por debajo de
     * MIN_HEALTH_FACTOR. Usuario que será liquidado.
     * @param _debtToCover La cantidad de CSC que deseas quemar para mejorar el factor de salud del usuario.
     *
     */
    function liquidate(
        address _tokenCollateral,
        address _user,
        uint256 _debtToCover
    )
        external
        moreThanZero(_debtToCover)
        nonReentrant
    {
        uint256 startingUserHealthFactor = _healthFactor(_user);
        if (startingUserHealthFactor >= MIN_HEALTH_FACTOR) revert CSCEngine__HealthFactorOk();
        uint256 tokenAmountFromDebtCovered = getTokenAmountFromUsd(_tokenCollateral, _debtToCover);
        //0.05 * 0.1 = 0.005. Obteniendo 0.055 ETH
        uint256 bonusCollateral = (tokenAmountFromDebtCovered * LIQUIDATION_BONUS) / LIQUIDATION_PRECISION;
        uint256 totalCollateralToRedeem = tokenAmountFromDebtCovered + bonusCollateral;
        _redeemCollateral(_user, msg.sender, _tokenCollateral, totalCollateralToRedeem);
        _burnCSC(_user, msg.sender, _debtToCover);

        uint256 endingUserHealthFactor = _healthFactor(_user);
        if (endingUserHealthFactor <= startingUserHealthFactor) revert CSCEngine__HealthFactorNotImproved();
        _revertIfHealthFactorIsBroken(msg.sender);
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                            PRIVATE & INTERNAL FUNCTIONS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    /**
     * @notice Función diseñada para quemar una cantidad específica de la criptomoneda estable (CSC) en nombre de un
     * tercero (_onBehalfOf).
     * @param _amountCscToBurn Es la cantidad de la criptomoneda estable (CSC) que se desea quemar.
     * @param _onBelhafOf Es la dirección del usuario en cuyo nombre se está quemando la criptomoneda estable. Indica
     * la cuenta para la cual se reduce la deuda o la cantidad de CSC en circulación.
     * @param _cscFrom Es la dirección desde la cual se está transfiriendo la cantidad de CSC a quemar. Indica la
     * cuenta desde la cual se realiza la transferencia de CSC hacia el contrato antes de la quema.
     * @dev Low-level internal function, no la llame, a menos que la funcion que llama, esté checkeando el rompimiento
     * del health factor.
     */
    function _burnCSC(address _onBelhafOf, address _cscFrom, uint256 _amountCscToBurn) private {
        //Removemos la deuda.
        s_CSCMinted[_onBelhafOf] -= _amountCscToBurn;
        bool success = i_cscToken.transferFrom(_cscFrom, address(this), _amountCscToBurn);
        if (!success) revert CSCEngine__TransferFailed();
        i_cscToken.burn(_amountCscToBurn);
    }

    /**
     * @notice Esta función, está diseñada para facilitar el retiro de una cantidad específica de
     * colateral entre dos direcciones de usuarios.
     * @param _tokenCollateralAddress Es la dirección del token de colateral que se va a redimir. Indica qué tipo de
     * colateral se está retirando.
     * @param _amountCollateral Es la cantidad de colateral que se va a redimir. Representa la cantidad específica de
     * tokens de colateral que el usuario desea retirar.
     * @param _from  Es la dirección del usuario desde la cual se está retirando el colateral. Indica la cuenta de la
     * cual se reduce la cantidad de colateral depositado. (Liquídado)
     * @param _to Es la dirección del usuario que está recibiendo el colateral redimido. Indica la cuenta a la cual se
     * transferirá la cantidad de colateral retirado. (Liquídador)
     */
    function _redeemCollateral(
        address _from,
        address _to,
        address _tokenCollateralAddress,
        uint256 _amountCollateral
    )
        private
    {
        s_collateralDeposited[_from][_tokenCollateralAddress] -= _amountCollateral;
        emit CollateralRedeemed(_from, _to, _tokenCollateralAddress, _amountCollateral);
        bool success = IERC20(_tokenCollateralAddress).transfer(_to, _amountCollateral);
        if (!success) revert CSCEngine__TransferFailed();
    }

    /**
     * @notice Internal function para obtener informacion de una cuenta.
     * @param _user Direccion del usuario.
     * @return totalCscMinted
     * @return collateralValueInUSD
     */

    function _getAccountInformation(address _user)
        private
        view
        returns (uint256 totalCscMinted, uint256 collateralValueInUSD)
    {
        totalCscMinted = s_CSCMinted[_user];
        collateralValueInUSD = getAccountCollateralValueInUSD(_user);
    }

    /**
     * @notice esta función calcula el factor de salud de una cuenta, teniendo en cuenta el colateral y la cantidad
     * total de DSC minted. El factor de salud es una métrica importante en DeFi que indica la relación entre el valor
     * del colateral y la deuda de un usuario. Un factor de salud más alto indica una posición financiera más segura.
     * @notice Verifica si la cantidad total de DSC minted es cero. Si es así, la función devuelve el valor máximo
     * posible de uint256.
     * @param _totalCscMinted Representa la cantidad total de tokens CSC que han sido minted o generados para una cuenta
     * en particular.
     * @param _collateralValueInUsd Representa el valor total del colateral asociado con la cuenta en dólares
     * estadounidenses
     */
    function _calculateHealthFactor(
        uint256 _totalCscMinted,
        uint256 _collateralValueInUsd
    )
        internal
        pure
        returns (uint256)
    {
        if (_totalCscMinted == 0) return type(uint256).max;
        uint256 collateralAdjustedForThreshold = (_collateralValueInUsd * LIQUIDATION_THRESHOLD) / LIQUIDATION_PRECISION;
        return (collateralAdjustedForThreshold * PRECISION) / _totalCscMinted;
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
        (uint256 _totalCscMinted, uint256 _collateralValueInUsd) = _getAccountInformation(_user);
        return _calculateHealthFactor(_totalCscMinted, _collateralValueInUsd);
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

    /**
     * @notice Esta función tiene como objetivo calcular el valor en dólares estadounidenses (USD) de una cierta
     * cantidad de un token específico.
     * @param _token La dirección del token del cual se está calculando el valor en USD.
     * @param _amount La cantidad del token para la que se quiere determinar el valor en USD.
     * @notice Se obtiene el precio del token en USD mediante un Price Feed (ChainLink) vinculado a ese token en
     * particular, utilizando la interfaz `AggregatorV3Interface`. Se accede a los datos más recientes del feed de
     * precios para obtener el valor del token en USD.
     * @notice  1 ETH = 1000 USD
     *     // The returned value from Chainlink will be 1000 * 1e8
     *     // Most USD pairs have 8 decimals, so we will just pretend they all do
     *     // We want to have everything in terms of WEI, so we add 10 zeros at the end
     *
     */

    function _getUsdValue(address _token, uint256 _amount) private view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeeds[_token]);
        (, int256 price,,,) = priceFeed.latestRoundData();
        // 1 ETH = 1000 USD
        // The returned value from Chainlink will be 1000 * 1e8
        // Most USD pairs have 8 decimals, so we will just pretend they all do
        // We want to have everything in terms of WEI, so we add 10 zeros at the end
        return ((uint256(price) * ADDITIONAL_FEED_PRECISION) * _amount) / PRECISION;
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                     PUBLIC & EXTERNAL VIEW PURE FUNCTIONS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    function calculateHealthFactor(
        uint256 _totalCscMinted,
        uint256 _collateralValueInUsd
    )
        external
        pure
        returns (uint256)
    {
        return _calculateHealthFactor(_totalCscMinted, _collateralValueInUsd);
    }

    /**
     * @notice Esta funcion tiene como objetivo calcular la cantidad de tokens ERC20 equivalentes que se pueden adquirir
     * utilizando una cantidad determinada de dólares estadounidenses en wei (unidad más pequeña de ether).
     * @param _tokenCollateral Es la dirección del token ERC20 utilizado como colateral cuyo precio en dólares se
     * utilizará para calcular la cantidad equivalente de tokens.
     * @param _usdAmounInWai  Es la cantidad de dólares estadounidenses expresados en wei, la unidad más pequeña de
     * ether, que se desea convertir en su equivalente en tokens del token de colateral especificado.
     */
    function getTokenAmountFromUsd(address _tokenCollateral, uint256 _usdAmounInWai) public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeeds[_tokenCollateral]);
        (, int256 price,,,) = priceFeed.latestRoundData();
        //(10e18 * 1e18) / ($2000e8 * 1e10)
        //0.005000000000000000
        return ((_usdAmounInWai * PRECISION) / (uint256(price) * ADDITIONAL_FEED_PRECISION));
    }

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

    function getUsdValue(address _token, uint256 _amount) public view returns (uint256) {
        return _getUsdValue(_token, _amount);
    }

    function getAccountInformation(address _user)
        external
        view
        returns (uint256 totalCscMinted, uint256 collateralValueInUSD)
    {
        (totalCscMinted, collateralValueInUSD) = _getAccountInformation(_user);
    }

        function getPrecision() external pure returns (uint256) {
        return PRECISION;
    }

    function getAdditionalFeedPrecision() external pure returns (uint256) {
        return ADDITIONAL_FEED_PRECISION;
    }

    function getLiquidationThreshold() external pure returns (uint256) {
        return LIQUIDATION_THRESHOLD;
    }

    function getLiquidationBonus() external pure returns (uint256) {
        return LIQUIDATION_BONUS;
    }

    function getLiquidationPrecision() external pure returns (uint256) {
        return LIQUIDATION_PRECISION;
    }

    function getMinHealthFactor() external pure returns (uint256) {
        return MIN_HEALTH_FACTOR;
    }

    function getCollateralTokens() external view returns (address[] memory) {
        return s_collateralTokens;
    }

    function getCsc() external view returns (address) {
        return address(i_cscToken);
    }

    function getCollateralTokenPriceFeed(address _token) external view returns (address) {
        return s_priceFeeds[_token];
    }

    function getHealthFactor(address _user) external view returns (uint256) {
        return _healthFactor(_user);
    }
}
