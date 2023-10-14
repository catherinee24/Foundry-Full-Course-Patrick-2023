// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

/**
 * @title A Sample Raffle Smart Contract Deploy
 * @author Catherine Maverick
 * @notice This contract is for creating a sample Raffle Smart Contract Script Deploy.
 */
contract DeployRaffle is Script {
    /**
     * Para deployar un contrato, hacemos una funcion llamada run(). Dentro de la funcion deployamos el contrato HelperConfig() que hicimos para saber con cual network estamos trabajando. Luego llamamos los parametros del contructor de nuestro contrato, que tambien definimos en el struct en el contrato HelperConfig().
     */
    function run() external returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        (
            uint256 entranceFee,
            uint256 interval,
            address vrfCoordinatorV2,
            bytes32 gasLane,
            uint64 suscriptionId,
            uint32 callbackGasLimit
        ) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        Raffle raffle = new Raffle(
            entranceFee,
            interval,
            vrfCoordinatorV2,
            gasLane,
            suscriptionId,
            callbackGasLimit
        );
        vm.stopBroadcast();

        return (raffle, helperConfig);
    }
}
