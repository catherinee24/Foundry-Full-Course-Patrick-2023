// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinatorV2;
        bytes32 gasLane;
        uint64 suscriptionId;
        uint32 callbackGasLimit;
    }
}