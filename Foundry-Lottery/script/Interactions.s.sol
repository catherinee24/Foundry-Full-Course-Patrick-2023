//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract CreateSubscriptions is Script {
    HelperConfig helperConfig;

    function subscriptionUsingConfig() public returns (uint64) {
        helperConfig = new HelperConfig();

        (, , address vrfCoordinatorV2, , , ) = helperConfig
            .activeNetworkConfig();
    }

    function createSubscription()

    function run() external returns (uint64) {
        return subscriptionUsingConfig();
    }
}
