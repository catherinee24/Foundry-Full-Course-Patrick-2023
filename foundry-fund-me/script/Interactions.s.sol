// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

/**
 * Creamos 2 contratos o los que necesitemos para testear nuestras funciones del FundMe.sol
 * en nuestro caso creamos 2 para testear la funcion fundMe y withdraw.
 */
contract FundFundMe is Script {
    uint256 public constant SEND_VALUE = 0.01 ether;

    /**
     * Funcion para interactuar con la funcion fund()
     */
    function fundFundMe(address _mostRecenctlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(_mostRecenctlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Fund me with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecenctlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecenctlyDeployed);
    }
}

contract WithdrawFundMe is Script {
    /**
     * Funcion para interactuar con la funcion fund()
     */
    function withdrawFundMe(address _mostRecenctlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(_mostRecenctlyDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecenctlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecenctlyDeployed);
    }
}
