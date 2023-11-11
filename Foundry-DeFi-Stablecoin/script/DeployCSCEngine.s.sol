// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { CSCEngine } from "../src/CSCEngine.sol";
import { DecentralizedStableCoin } from "../src/DecentralizedStableCoin.sol";

contract DeployCSCEngine is Script {
    CSCEngine cscEngine;
    DecentralizedStableCoin decentralizedStableCoin;

    function run() external returns (DecentralizeStableCoin, CSCEngine) {
        vm.startBroadcast();
        decentralizedStableCoin = new DecentralizedStableCoin();
        cscEngine = new CSCEngine();
        vm.stopBroadcast();
    }
}
