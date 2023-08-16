// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;
/**
 * Para hacer un script:
 *  1. Importamos el archivo Script de la libreria forge-std. 
 *  2. importamos el contrato que queramos deployar.
 *
 */

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    /**
     * Empezamos el Script con una funcion publica llamada run() que devolvera el contrato a deployar
     */
    function run() external returns (SimpleStorage) {
        /**
         * vm.startBroadcast() nos dice: Hey todo lo que esta despues de esta linea dentro de esta funcion
         *     deberias de enviarlo al RPC. Todo lo que esta aqui dentro: 
         *     vm.startBroadcast();
         *     SimpleStorage simpleStorage = new SimpleStorage();
         *     vm.stopBroadcast(); Es lo que vamos a deployar
         */
        vm.startBroadcast();
        SimpleStorage simpleStorage = new SimpleStorage();
        /**
         * new keyword crea un nuevo contrat
         */
        vm.stopBroadcast();
        return simpleStorage;
    }
}
