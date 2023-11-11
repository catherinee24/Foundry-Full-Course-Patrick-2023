// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { CSCEngine } from "../src/CSCEngine.sol";
import { DecentralizedStableCoin } from "../src/DecentralizedStableCoin.sol";
import { HelperConfig } from "../script/HelperConfig.s.sol";

contract DeployCSCEngine is Script {
    address[] public tokenAdresses;
    address[] public priceFeedAddresses;

    function run() external returns (DecentralizedStableCoin, CSCEngine) {
        HelperConfig helperConfig = new HelperConfig();

        (address wethUsdPriceFeed, address wbtcUsdPriceFeed, address weth, address wbtc, uint256 deployerKey) =
            helperConfig.activeNetworkConfig();

        tokenAdresses = [weth, wbtc];
        priceFeedAddresses = [ethUsdPriceFeed, wbtcUsdPriceFeed];

        vm.startBroadcast();
        DecentralizedStableCoin csc = new DecentralizedStableCoin();
        CSCEngine cscEngine = new CSCEngine(tokenAdresses, priceFeedAddresses, csc);
        vm.stopBroadcast();
    }
}
