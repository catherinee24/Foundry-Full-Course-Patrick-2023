// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { CSCEngine } from "../src/CSCEngine.sol";
import { DecentralizedStableCoin } from "../src/DecentralizedStableCoin.sol";
import { HelperConfig } from "../script/HelperConfig.s.sol";

/**
 * /// @title DeployCSCEngine
 * /// @author Catherine Maverick from CatellaTech.
 * /// @notice Automatiza el proceso de despliegue de dos contratos (DecentralizedStableCoin, CSCEngine)
 * /// @dev Usa la información obtenida del contrato HelperConfig y la configuración activa de tokens y feeds de
 * precios en la red.
 */

contract DeployCSCEngine is Script {
    address[] public tokenAdresses;
    address[] public priceFeedAddresses;

    function run() external returns (DecentralizedStableCoin, CSCEngine, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();

        (address wethUsdPriceFeed, address wbtcUsdPriceFeed, address weth, address wbtc, uint256 deployerKey) =
            helperConfig.activeNetworkConfig();

        tokenAdresses = [weth, wbtc];
        priceFeedAddresses = [wethUsdPriceFeed, wbtcUsdPriceFeed];

        vm.startBroadcast(deployerKey);
        DecentralizedStableCoin csc = new DecentralizedStableCoin();
        CSCEngine cscEngine = new CSCEngine(tokenAdresses, priceFeedAddresses, address(csc));
        csc.transferOwnership(address(cscEngine));
        vm.stopBroadcast();
        return (csc, cscEngine, helperConfig);
    }
}
