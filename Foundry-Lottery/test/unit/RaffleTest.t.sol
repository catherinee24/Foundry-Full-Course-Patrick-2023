//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {Vm} from "forge-std/Vm.sol";

contract RaffleTest is Test {
    /**
     * Variables de los contratos que vamos a deployar
     */
    DeployRaffle deployer;
    Raffle raffle;
    HelperConfig helperConfig;

    // Creamos un jugador para que interactue con nuestras funciones.
    address public PLAYER = makeAddr("Player");
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinatorV2;
    bytes32 gasLane;
    uint64 suscriptionId;
    uint32 callbackGasLimit;

    /**
     * Funcion setUp(). Todo lo que se escriba en esta funcion sera tomado en cuenta en la funciones de Test que vayamos a crear
     */
    function setUp() external {
        deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.run();

        (entranceFee, interval, vrfCoordinatorV2, gasLane, suscriptionId, callbackGasLimit) =
            helperConfig.activeNetworkConfig();
    }

    function testRaffleInitializesInOpenState() public view {
        // Escribimos Raffle.RaffleState.OPEN diciendo: en el contrato `Raffle` encuentra un type `RaffleState` y que este OPEN.
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    /*//////////////////////////////////////////////////////////////
                         ENTER RAFFLE TEST
    //////////////////////////////////////////////////////////////*/
    function testRaffleRevertsWhenYouDontPayEnough() public {
        // Arrange
        vm.prank(PLAYER);

        // Act /Assert
        vm.expectRevert(Raffle.Raffle__NOT__ENOUGH__ETH.selector);
        raffle.enterRaffle();
    }

    function testRaffleRecordsPlayerWhenTheyEnter() public {
        vm.startPrank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        address playerRecorded = raffle.getPlayer(0);
        assert(playerRecorded == PLAYER);
    }    
}
