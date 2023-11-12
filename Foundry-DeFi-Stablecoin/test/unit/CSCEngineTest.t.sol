// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { DeployCSCEngine } from "../../script/DeployCSCEngine.s.sol";
import { DecentralizedStableCoin } from "../../src/DecentralizedStableCoin.sol";
import { CSCEngine } from "../../src/CSCEngine.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";

contract CSCEngineTest is Test {
    DeployCSCEngine deployer;
    DecentralizedStableCoin cscStableCoin;
    CSCEngine cscEngine;
    HelperConfig helperConfig;
    address wethUsdPriceFeed;
    address weth;

    function setUp() public {
        deployer = new DeployCSCEngine();
        (cscStableCoin, cscEngine, helperConfig) = deployer.run();
        (wethUsdPriceFeed,, weth,,) = helperConfig.activeNetworkConfig();
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    PRICE TESTS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    //     function getUsdValue(address _token, uint256 _amount) public view returns (uint256) {
    //     AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeeds[_token]);
    //     (, int256 price,,,) = priceFeed.latestRoundData();
    //     return ((uint256(price) * ADDITIONAL_FEED_PRECISION) * _amount) / PRECISION;
    // }
    function testGetUsdValue() public {
        uint256 ethAmount = 15 ether;
        //15e18*2000/ETH = 30,000e18
        uint256 expectedUsd = 30_000 ether;
        uint256 actualUsd = cscEngine.getUsdValue(weth, ethAmount);
        assertEq(expectedUsd, actualUsd);
    }
}
