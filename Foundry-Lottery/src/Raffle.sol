// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title: A Sample Raffle Smart Contract
 * @author Catherine Maverick
 * @notice: This contract is for creating a sample Raffle Smart Contract
 * @dev: Implements Chainlink VRFv2
 */
contract Raffle {
    /**
     * ERRORS
     */
    error Raffle__NOT__ENOUGH__ETH();

    /**
     * VARIABLES DE ESTADO 
     * Hacemos las variables de estado (privadas) porque luego vamos a hacer las funciones (getters) de dichas variables
     *     1. La primera varible es el (fee) que las personas pagaran al entrar en la rifa.
     *     2. Un array de addressess payable para traquear a los jugadores.
     */
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;

    /**
     * EVENTS
     */
    event EnteredRaflle(address indexed player);

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    /**
     * 1. Hacemos una funcion para que las personas puedan entrar a la loteria.
     *         1.2 - Queremos que las personan paguen algo de ETH para que puedan entrar a la loteria.
     *         1.3 - Hacemos la funcion (payable) así la funcion puede recibir ETH.
     */
    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) revert Raffle_NOT_ENOUGH_ETH();
        s_players.push(payable(msg.sender));
        emit EnteredRaflle(msg.sender);
    }

    /** */
    function pickWinner() public {}

    /**
     * Getter Functions
     */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
