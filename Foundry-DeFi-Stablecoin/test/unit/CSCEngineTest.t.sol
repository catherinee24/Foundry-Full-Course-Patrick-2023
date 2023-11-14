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
     * @notice Este test asegura que el constructor del contrato `CSCEngine` revierta la transacción si las listas de direcciones
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
}
