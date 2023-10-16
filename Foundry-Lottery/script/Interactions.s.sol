//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {LinkToken} from "../test/mocks/LinkToken.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract CreateSubscriptions is Script {
    HelperConfig helperConfig;

    function subscriptionUsingConfig() public returns (uint64) {
        helperConfig = new HelperConfig();

        (, , address vrfCoordinatorV2, , , , ) = helperConfig
            .activeNetworkConfig();

        return createSubscription(vrfCoordinatorV2);
    }

    function createSubscription(
        address vrfCoordinatorV2
    ) public returns (uint64) {
        console.log("createSubscription on ChaniId:", block.chainid);
        vm.startBroadcast();
        uint64 subId = VRFCoordinatorV2Mock(vrfCoordinatorV2)
            .createSubscription();
        vm.stopBroadcast();

        console.log("Your subId is:", subId);
        console.log("Please update subscriptionId in HelperConfig.s.sol");
        return subId;
    }

    function run() external returns (uint64) {
        return subscriptionUsingConfig();
    }
}

contract FundSubscription is Script {
    uint96 public constant FUND_AMOUNT = 3 ether;

    function fundSubscriptionUsingConfig() public {
        HelperConfig helperConfig = new HelperConfig();
        (
            ,
            ,
            address vrfCoordinatorV2,
            ,
            uint64 subscriptionId,
            ,
            address link
        ) = helperConfig.activeNetworkConfig();

        fundSubscription(vrfCoordinatorV2, subscriptionId, link);
    }

    function fundSubscription(
        address vrfCoordinatorV2,
        uint64 subscriptionId,
        address link
    ) public {
        console.log("Funding subscription:", subscriptionId);
        console.log("Using VRFCoordinator:", vrfCoordinatorV2);
        console.log("On ChainId:", block.chainid);
        if (block.chainid == 31337) {
            vm.startBroadcast();
            VRFCoordinatorV2Mock(vrfCoordinatorV2).fundSubscription(
                subscriptionId,
                FUND_AMOUNT
            );
            vm.stopBroadcast();
        } else {
            vm.startBroadcast();
            LinkToken(link).transferAndCall(
                vrfCoordinatorV2,
                FUND_AMOUNT,
                abi.encode(subscriptionId)
            );
            vm.stopBroadcast();
        }
    }

    function run() external {
        fundSubscriptionUsingConfig();
    }
}

contract AddConsumer is Script {
    function AddConsumer(
        address raffle,
        address vrfCoordinatorV2,
        uint64 subscriptionId
    ) public {
        console.log("Adding consumer contracr:", raffle);
        console.log("Using VRFCoordinatorV2:", vrfCoordinatorV2);
        console.log("On ChainId:",subscriptionId);
    }

    function addConsumerUsingConfig(address raffle) public {
        HelperConfig helperConfig = new HelperConfig();
        (
            ,
            ,
            address vrfCoordinatorV2,
            ,
            uint64 subscriptionId,
            ,
            ,

        ) = helperConfig.activeNetworkConfig();
        addConsumer(raffle, vrfCoordinatorV2, subscriptionId);
    }

    function run() external {
        address raffle = DevOpsTools.get_most_recent_deployment(
            "Raffle",
            block.chainid
        );
        addConsumerUsingConfig(raffle);
    }
}
