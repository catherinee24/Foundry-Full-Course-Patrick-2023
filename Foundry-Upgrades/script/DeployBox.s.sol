// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
contract DeployBox is Script {
    function run() external returns (address){
        vm.startBroadcast();
        address proxy = deployBox();
        vm.stopBroadcast();
    }

    function deployBox() public returns(address){
        BoxV1 boxV1 = new BoxV1(); // Implementation contract (Logic)
    }
}