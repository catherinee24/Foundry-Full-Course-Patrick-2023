// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

/**
 * @title A Sample Raffle Smart Contract
 * @author Catherine Maverick
 * @notice This contract is for creating a sample Raffle Smart Contract
 * @dev Implements Chainlink VRFv2
 */
contract Raffle {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    error Raffle__NOT__ENOUGH__ETH();

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

    uint256 private constant REQUEST_CONFIRMATIONS = 3;
    uint256 private constant NUM_WORDS = 1;

    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    uint64 private immutable i_suscriptionId;
    uint32 private immutable i_callbackGasLimit;
    address private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane; // keyHash

    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event EnteredRaflle(address indexed player);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint64 suscriptionId,
        uint32 callbackGasLimit
    ) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_vrfCoordinator = vrfCoordinator;
        i_suscriptionId = suscriptionId;
        i_gasLane = gasLane;
        i_callbackGasLimit = callbackGasLimit;
        s_lastTimeStamp = block.timestamp;
    }

    /*//////////////////////////////////////////////////////////////
                                FUNCTIONS
     //////////////////////////////////////////////////////////////*/

    /// @notice Funcion para que los jugadores entren a la Rifa.
    /// @dev Hacemos la funcion (payable) así la funcion puede recibir ETH.
    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) revert Raffle_NOT_ENOUGH_ETH();
        s_players.push(payable(msg.sender));
        emit EnteredRaflle(msg.sender);
    }

    /// @notice Funcion para obtener un numero aleatorio.
    /// @dev Usamos el numero random para agarrar un jugador.
    function pickWinner() public {
        /**
         * Chequeamos si ha pasado el tiempo suficiente para elegir un ganador
         */
        if ((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert;
        }

        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane, i_suscriptionId, REQUEST_CONFIRMATIONS, i_callbackGasLimit, NUM_WORDS
        );
    }

    /*//////////////////////////////////////////////////////////////
                          GETTERS FUNCTIONS
     //////////////////////////////////////////////////////////////*/

    /// @notice Retorna el fee que ha pagado un jugador.
    /// @dev Returns only a fixed number.
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
