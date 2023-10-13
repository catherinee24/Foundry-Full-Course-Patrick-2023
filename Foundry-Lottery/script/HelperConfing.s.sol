// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";

contract HelperConfig is Script, VRFCoordinatorV2Mock {

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinatorV2;
        bytes32 gasLane; 
        uint64 suscriptionId;
        uint32 callbackGasLimit;
    }

    constructor() {
        // SEPOLIA CHAINID 11155111
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public view returns(NetworkConfig memory){
        return NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinatorV2: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625,
            gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c, // Keyhash: https://docs.chain.link/vrf/v2/subscription/supported-networks
            suscriptionId: 0,
            callbackGasLimit: 500000 // 500,000 gas!!
        });
    }

    function getOrCreateAnvilEthConfig() public view returns(NetworkConfig memory){
        if(activeNetworkConfig.vrfCoordinatorV2 != address(0)){
            return activeNetworkConfig;
        }
    }
}