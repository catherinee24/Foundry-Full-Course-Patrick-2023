//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
contract RaffleTest is Test {
    /**Variables de los contratos que vamos a deployar */
    DeployRaffle deployer;
    Raffle raffle;
    HelperConfig heplperConfig;

    // Creamos un jugador para que interactue con nuestras funciones.
    address public PLAYER = makeAddr("Player");

    //Distribuimos algo de ether al jugador.
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    /** Funcion setUp(). Todo lo que se escriba en esta funcion sera tomado en cuenta en la funciones de Test que vayamos a crear  */
    function setUp() external {
        deployer = new DeployRaffle();
        (raffle, heplperConfig) = deployer.run();
     

    }
}