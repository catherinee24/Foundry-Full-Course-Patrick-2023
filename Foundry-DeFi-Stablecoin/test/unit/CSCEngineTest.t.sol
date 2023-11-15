// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { DeployCSCEngine } from "../../script/DeployCSCEngine.s.sol";
import { DecentralizedStableCoin } from "../../src/DecentralizedStableCoin.sol";
import { CSCEngine } from "../../src/CSCEngine.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract CSCEngineTest is Test {
    DeployCSCEngine deployer;
    DecentralizedStableCoin cscStableCoin;
    CSCEngine cscEngine;
    HelperConfig helperConfig;
    address wethUsdPriceFeed;
    address weth;
    address wbtcUsdPriceFeed;
    address wbtc;

    address public USER = makeAddr("user");
    uint256 public constant AMOUNT_COLLATERAL = 10 ether;
    uint256 public constant STARTING_ERC20_BALANCE = 10 ether;

    function setUp() public {
        deployer = new DeployCSCEngine();
        (cscStableCoin, cscEngine, helperConfig) = deployer.run();
        (wethUsdPriceFeed, wbtcUsdPriceFeed, weth, wbtc,) = helperConfig.activeNetworkConfig();

        //Le minteamos el token weth al USER.
        ERC20Mock(weth).mint(USER, STARTING_ERC20_BALANCE);
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                CONSTRUCTOR TESTS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    /**
     * @notice Este test asegura que el constructor del contrato `CSCEngine` revierta la transacción si las listas de
     * direcciones
     * de tokens y direcciones de feeds de precios no tienen la misma longitud, lo cual es un requisito según la lógica
     * del contrato.
     */
    address[] public tokenAddresses;
    address[] public priceFeedAddresses;

    function testRevertsIfTokenLengthDoesNotMatchPriceFeeds() public {
        tokenAddresses.push(weth);
        priceFeedAddresses.push(wethUsdPriceFeed);
        priceFeedAddresses.push(wbtcUsdPriceFeed);

        vm.expectRevert(CSCEngine.CSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength.selector);
        new CSCEngine(tokenAddresses, priceFeedAddresses, address(cscStableCoin));
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                PRICE FEED TESTS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    function testGetUsdValue() public {
        uint256 ethAmount = 15 ether;
        //15ETH*2000ETH = 30,000ETH
        uint256 expectedUsd = 30_000 ether;
        uint256 actualUsd = cscEngine.getUsdValue(weth, ethAmount);
        assertEq(expectedUsd, actualUsd);
    }

    // En esta función haremos lo opuesto a testGetUsdValue().
    function testGetTokenAmountFromUsd() public {
        uint256 usdAmount = 100 ether;
        //2000 ETH / $100 = 0.05
        uint256 expectedWeth = 0.05 ether;
        uint256 actualWeth = cscEngine.getTokenAmountFromUsd(weth, usdAmount);
        assertEq(expectedWeth, actualWeth);
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                            DEPOSIT COLLATERAL TESTS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    function testRevertsIfCollateralIsZero() public {
        vm.startPrank(USER);
        ERC20Mock(weth).approve(address(cscEngine), AMOUNT_COLLATERAL);

        vm.expectRevert(CSCEngine.CSCEngine__NeedsMoreThanZero.selector);
        cscEngine.depositCollateral(weth, 0);
        vm.stopPrank();
    }

    function testRevertsWithUnapprovedCollateral() public {
        ERC20Mock ranToken = new ERC20Mock();
        vm.startPrank(USER);
        vm.expectRevert(CSCEngine.CSCEngine__TokenNotAllowed.selector);
        cscEngine.depositCollateral(address(ranToken), AMOUNT_COLLATERAL);
        vm.stopPrank();
    }

    //Creamos un modifier ya que vamos a estar haciendo mucho deposit. De esta manera evitamos repetrir codigo a lo
    // largo del test. 🤯
    modifier depositCollateral() {
        vm.startPrank(USER);
        ERC20Mock(weth).approve(address(cscEngine), AMOUNT_COLLATERAL);
        cscEngine.depositCollateral(weth, AMOUNT_COLLATERAL);
        vm.stopPrank();
        _;
    }

    /**
     * @notice Este test, llamado `testCanDepositCollateralAndGetAccountInfo`, tiene como objetivo verificar que el
     * proceso de depositar colateral y obtener información de la cuenta en el contrato `cscEngine` funcione
     * correctamente.
     */
    function testCanDepositCollateralAndGetAccountInfo() public depositCollateral {
        (uint256 totalCscMinted, uint256 collateralValueInUSD) = cscEngine.getAccountInformation(USER);

        //Vamos a asegurarnos de que los valores de `totalCscMinted` y `collateralValueInUSD` sean correctos.
        uint256 expectedTotalCscMinted = 0;
        uint256 expectedDepositAmount = cscEngine.getTokenAmountFromUsd(weth, collateralValueInUSD);
        assertEq(totalCscMinted, expectedTotalCscMinted);
        assertEq(AMOUNT_COLLATERAL, expectedDepositAmount);
    }

    // Este test tiene como objetivo verificar que, después de depositar colateral en el contrato cscEngine, el saldo del usuario
    // en la criptomoneda estable (cscStableCoin) no cambia, es decir, que no se emiten nuevas unidades de la
    // criptomoneda estable en este proceso.
    function testCanDepositCollateralWithoutMinting() public depositCollateral {
        uint256 userBalance = cscStableCoin.balanceOf(USER);
        assertEq(userBalance, 0);
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    depositCollateralAndMintDsc TESTS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/

}
