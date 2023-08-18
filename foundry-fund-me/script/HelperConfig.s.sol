// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // si estamos en Anvil  deployamos Mocks
    // y si no es anvil agarramos la dirección existente del live network
    NetworkConfing public activeNetworkConfing;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e18;

    struct NetworkConfing {
        address priceFeed; // ETH/USD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfing = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfing = getMainnetEthConfig();
        } else {
            activeNetworkConfing = getOrCreateAnvilEthConfig();
        }
    }

    // SEPOLIA TEST NETWORK
    function getSepoliaEthConfig() public pure returns (NetworkConfing memory) {
        //Price feed address
        NetworkConfing memory sepoliaConfig = NetworkConfing({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    // ETH MAINNET
    function getMainnetEthConfig() public pure returns (NetworkConfing memory) {
        //Price feed address
        NetworkConfing memory ethConfig = NetworkConfing({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfing memory) {
        //Price feed address
        /**
         * 1. Deploy the Mocks
         *     2. Return the Mocks addresses
         */
        if (activeNetworkConfing.priceFeed != address(0)) {
            return activeNetworkConfing;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfing memory anvilConfig = NetworkConfing({priceFeed: address(mockPriceFeed)});
        return anvilConfig;
    }
}
