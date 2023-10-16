//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";


contract CreateSubscriptions is Script {
    HelperConfig helperConfig;

    function subscriptionUsingConfig() public returns (uint64) {
        helperConfig = new HelperConfig();

        (,, address vrfCoordinatorV2,,,) = helperConfig.activeNetworkConfig();

        return createSubscription(vrfCoordinatorV2);
    }

    function createSubscription(address vrfCoordinatorV2) public returns (uint64) {
        console.log("createSubscription on ChaniId:", block.chaniId);
        vm.startBroadcast();
        uint64 subId = VRFCoordinatorV2Mock(vrfCoordinatorV2).createSubscription();
        vm.stopBroadcast();
        
        console.log("Your subId is:", subId);
        console.log("Please update subscriptionId in HelperConfig.s.sol");
        return subId;
    }

    function run() external returns (uint64) {
        return subscriptionUsingConfig();
    }
}
