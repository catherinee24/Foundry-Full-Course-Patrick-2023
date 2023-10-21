//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "../../lib/chainlink-brownie-contracts/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";

contract RaffleTest is Test {
    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    event EnteredRaflle(address indexed player);

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
    uint64 subscriptionId;
    uint32 callbackGasLimit;
    address link;

    /**
     * Funcion setUp(). Todo lo que se escriba en esta funcion sera tomado en cuenta en la funciones de Test que vayamos a crear
     */
    function setUp() external {
        deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.run();

        (
            entranceFee,
            interval,
            vrfCoordinatorV2,
            gasLane,
            subscriptionId,
            callbackGasLimit,
            link
        ) = helperConfig.activeNetworkConfig();

        vm.deal(PLAYER, STARTING_USER_BALANCE);
    }

    function testRaffleInitializesInOpenState() public view {
        // Escribimos Raffle.RaffleState.OPEN diciendo: en el contrato `Raffle` encuentra un type `RaffleState` y que este OPEN.
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    /*//////////////////////////////////////////////////////////////
                         enterRaffle() TEST
    //////////////////////////////////////////////////////////////*/
    /**
     */
    function testRaffleRevertsWhenYouDontPayEnough() public {
        // Arrange
        vm.prank(PLAYER);

        // Act /Assert
        vm.expectRevert(Raffle.Raffle__NOT__ENOUGH__ETH.selector);
        raffle.enterRaffle();
    }

    function testRaffleRecordsPlayerWhenTheyEnter() public {
        //Arrange
        vm.startPrank(PLAYER);

        //Act
        raffle.enterRaffle{value: entranceFee}();
        address playerRecorded = raffle.getPlayer(0);

        //Assert
        assert(playerRecorded == PLAYER);
    }

    function testEmitsEventOnEntrance() public {
        vm.startPrank(PLAYER);
        vm.expectEmit(true, false, false, false, address(raffle));
        emit EnteredRaflle(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
    }

    function testCantEnterWhenRaffleIsCalculating() public {
        vm.startPrank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();

        //Sets **block.timestamp**.
        vm.warp(block.timestamp + interval + 1);
        //Sets **block.number**.
        vm.roll(block.number + 1);
        raffle.performUpkeep("");

        vm.expectRevert(Raffle.Raffle__RAFFLE__NOT__OPEN.selector);
        vm.startPrank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
    }

    /*//////////////////////////////////////////////////////////////
                         checkUpKeep() TEST
    //////////////////////////////////////////////////////////////*/
    function testCheckUpKeepReturnsFalseIfItHasNoBalance() public {
        //Arrange
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);

        //Act
        (bool upKeepNeeded, ) = raffle.checkUpKeep("");

        //Assert
        assert(!upKeepNeeded);
    }

    function testCheckUpKeepReturnsFalseIfRaffleNotOpen() public {
        //Arrange
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);
        raffle.performUpkeep("");

        //Act
        (bool upKeepNedeed, ) = raffle.checkUpKeep("");

        //Assert
        assert(upKeepNedeed == false);
    }

    function testCheckUpKeepReturnsFalseIfEnoughTimeHasPassed() public {
        //Arrange
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();

        //Act
        (bool upKeepNedeed, ) = raffle.checkUpKeep("");

        //Assert
        assert(!upKeepNedeed);
    }

    function testCheckUpKeepRetursTrueWhenParametersAreGood() public {
        //Arrenge
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);

        //Act
        (bool upKeepNedeed, ) = raffle.checkUpKeep("");

        //Assert
        assert(upKeepNedeed);
    }

    /*//////////////////////////////////////////////////////////////
                         performUpkeep() TEST
    //////////////////////////////////////////////////////////////*/
    function testPerformUpKeekCanOnlyRunIfCheckUpKeepIsTrue() public {
        //Arrange
        vm.startPrank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);

        //Act //Assert
        raffle.performUpkeep("");
    }

    function testPerformUpKeepRvertsWhenCheckUpKeepIsFalse() public {
        //Arrange
        uint256 currentBalance = 0;
        uint256 numPlayers = 0;
        uint256 raffleState = 0;

        //Act // Assert
        vm.expectRevert(
            abi.encodeWithSelector(
                Raffle.Raffle__UpKeepNotNeeded.selector,
                currentBalance,
                numPlayers,
                raffleState
            )
        );
        raffle.performUpkeep("");
    }

    modifier raffleEnteredAndTimePassed() {
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);
        _;
    }

    //Que si necesito testear usando el output de un evento??
    function testPerfomrUpKeepUpdatesRaffleStateAndEmitRequestId()
        public
        raffleEnteredAndTimePassed
    {
        //Act
        // Lo que esto va a hacer es guardar automaticamente todos los Logs outputs en getRecordedLogs().
        vm.recordLogs();
        raffle.performUpkeep("");

        //Este es un tipado especial que viene con Foundry test.
        Vm.Log[] memory entries = vm.getRecordedLogs();
        bytes32 requestId = entries[1].topics[1];

        Raffle.RaffleState rState = raffle.getRaffleState();
        // De este modo nos aseguramos de que el evento `requestId` se generó.
        assert(uint256(requestId) > 0);
        assert(uint256(rState) == 1);
    }

    /*//////////////////////////////////////////////////////////////
                         fulfillRandomWords() TEST
    //////////////////////////////////////////////////////////////*/
    function testfulfillRandomWordsCanOnlyBeCalledAfterPerformUpkeep(
        uint256 _randomRequestId
    ) public raffleEnteredAndTimePassed {
        //Arrange
        vm.expectRevert("nonexistent request");
        VRFCoordinatorV2Mock(vrfCoordinatorV2).fulfillRandomWords(
            _randomRequestId,
            address(raffle)
        );
    }

    function testfulfillRandomWordsPicksAWinnerResetsAndSendsMoney()
        public
        raffleEnteredAndTimePassed
    {
        //Arrange
        uint256 aditionalEntrants = 5;
        uint256 startingIndex = 1;

        for (
            uint256 i = startingIndex;
            i < startingIndex + aditionalEntrants;
            i++
        ) {
            address player = address(uint160(i)); // Podemos hacer un makeAdd().
            hoax(player, STARTING_USER_BALANCE); // hoax -----> Establece un prank de una dirección que tiene algo de éter.
            raffle.enterRaffle{value: entranceFee}();
        }

        uint256 prize = entranceFee * (aditionalEntrants + 1);

        //Act
        vm.recordLogs();
        raffle.performUpkeep(""); //Emit requestId
        Vm.Log[] memory entries = vm.getRecordedLogs();
        bytes32 requestId = entries[1].topics[1];

        uint256 previousTimestamp = raffle.getLastTimestamp();

        //Tenemos que pretender ser Chainlink VRF para elegir un Random Number y elegir un ganador.
        VRFCoordinatorV2Mock(vrfCoordinatorV2).fulfillRandomWords(
            uint256(requestId), // En el Contrato VRFCoordinatorV2Mock.sol el `requestId` es un type uint256 asi que hacemos el casteo.
            address(raffle)
        );

        //Asserts
        // assert(uint256(raffle.getRaffleState()) == 0); // La Rifa tiene que estar OPEN.
        // assert(raffle.getRecentWinner() != address(0)); // El ganador no puede ser la dirección `0`.
        // assert(raffle.getLengthOfPlayers() == 0); // Despues de elegir un ganador se reestablecen los jugadores, para que haya una rifa nueva.
        // assert(previousTimestamp < raffle.getLastTimestamp()); // El tiempo debería ser actualizado.
        assert(
            raffle.getRecentWinner().balance ==
                STARTING_USER_BALANCE + prize - entranceFee
        ); //El balance del ganador deberia ser mas despues de ganar la rifa.
    }
}
