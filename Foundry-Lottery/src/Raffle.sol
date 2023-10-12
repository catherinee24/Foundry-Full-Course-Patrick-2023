// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

/**
 * @title A Sample Raffle Smart Contract
 * @author Catherine Maverick
 * @notice This contract is for creating a sample Raffle Smart Contract
 * @dev Implements Chainlink VRFv2
 */
contract Raffle is VRFConsumerBaseV2 {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    error Raffle__NOT__ENOUGH__ETH();
    error Raffle__TRANSFER__FAILED();
    error Raffle__RAFFLE__NOT__OPEN();

    /*//////////////////////////////////////////////////////////////
                          TYPE DECLARATIONS
     //////////////////////////////////////////////////////////////*/
    enum RaffleState {
        OPEN, // 0
        CALCULATING // 1
    }

    /*//////////////////////////////////////////////////////////////
                         VARIABLES DE ESTADO
    //////////////////////////////////////////////////////////////*/

    /**
     * Hacemos las variables de estado (privadas) porque luego vamos a hacer las funciones (getters) de dichas variables
     *     @dev i_entranceFee = (fee) que las personas pagaran al entrar en la rifa.
     *     @dev i_interval = Duracion de la loteria en segundos.
     *     @dev s_players = array de addressess payable para traquear a los jugadores.
     *     @dev s_lastTimeStamp = El ultimo tiempo en segundos.
     */

    //Chainlink VRF Variables

    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    uint256 private immutable i_interval;
    uint64 private immutable i_suscriptionId;
    uint32 private immutable i_callbackGasLimit;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane; // keyHash

    // Lottery Variables
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;
    address private s_recentWinner;
    RaffleState private s_raffleState;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event EnteredRaflle(address indexed player);
    event PickedWinner(address indexed winner);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinatorV2,
        bytes32 gasLane,
        uint64 suscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_suscriptionId = suscriptionId;
        i_interval = interval;
        i_gasLane = gasLane;
        i_callbackGasLimit = callbackGasLimit;
        i_entranceFee = entranceFee;

        s_raffleState = RaffleState.OPEN;
        s_lastTimeStamp = block.timestamp;
    }

    /*//////////////////////////////////////////////////////////////
                                FUNCTIONS
     //////////////////////////////////////////////////////////////*/

    /// @notice Funcion para que los jugadores entren a la Rifa.
    /// @dev Hacemos la funcion (payable) así la funcion puede recibir ETH.
    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NOT__ENOUGH__ETH();
        }

        if (s_raffleState != RaffleState.OPEN) {
            revert Raffle__RAFFLE__NOT__OPEN();
        }

        s_players.push(payable(msg.sender));
        emit EnteredRaflle(msg.sender);
    }

    /**
     * @dev This is the function that the Chainlink Keeper nodes call
     * they look for `upkeepNeeded` to return True.
     * the following should be true for this to return true:
     * 1. The time interval has passed between raffle runs.
     * 2. The lottery is open.
     * 3. The contract has ETH.
     * 4. Implicity, your subscription is funded with LINK.
     */
    function checkUpKeep(bytes memory /*checkData*/ )
        public
        view
        returns (bool upKeepNeeded, bytes memory /*performData*/ )
    {
        bool timeHasPassed = (block.timestamp - s_lastTimeStamp) >= i_interval;
        bool isOpen = s_raffleState == RaffleState.OPEN;
        bool hasBalance = address(this).balance > 0;
        bool hasPlayers = s_players.length > 0;

        upKeepNeeded = (timeHasPassed && isOpen && hasBalance && hasPlayers);
        return (upKeepNeeded, "0x0");
    }

    /// @notice Funcion para obtener un numero aleatorio.
    /// @dev Usamos el numero random para agarrar un jugador.
    function pickWinner() public {
        /**
         * Chequeamos si ha pasado el tiempo suficiente para elegir un ganador
         */
        if ((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert();
        }

        s_raffleState = RaffleState.CALCULATING;

        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane, i_suscriptionId, REQUEST_CONFIRMATIONS, i_callbackGasLimit, NUM_WORDS
        );
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        /**
         * Patrón de diseño [Checks - Effects - Interactions] Para evitar bugs como reentrancy
         *         CHECKS
         *         require() or (if --> errors)
         */

        /**
         * EFFECTS (Our own contract)
         */
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable winner = s_players[indexOfWinner];
        s_recentWinner = winner;
        s_raffleState = RaffleState.OPEN;

        // Reseteamos el array para que haya una nueva rifa.
        s_players = new address payable[](0);
        s_lastTimeStamp = block.timestamp;
        emit PickedWinner(winner);

        /**
         * INTERACTIONS (With other contracts)
         */
        (bool success,) = winner.call{value: address(this).balance}("");
        if (!success) revert Raffle__TRANSFER__FAILED();
    }

    /*//////////////////////////////////////////////////////////////
                          GETTERS FUNCTIONS
     //////////////////////////////////////////////////////////////*/

    /// @notice Retorna el fee que ha pagado un jugador.
    /// @dev Returns only a fixed number.
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }
}
