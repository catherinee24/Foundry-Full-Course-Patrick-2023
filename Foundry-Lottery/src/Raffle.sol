// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title: A Sample Raffle Smart Contract
 * @author Catherine Maverick
 * @notice: This contract is for creating a sample Raffle Smart Contract
 * @dev: Implements Chainlink VRFv2
 */
contract Raffle {
    error Raffle__NOT__ENOUGH__ETH();
    /**
     * Hacemos las variables de estado (privadas) porque luego vamos a hacer las funciones (getters) de dichas variables
     */
    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    /**
     * 1. Hacemos una funcion para que las personas puedan entrar a la loeteria.
     *         1.2 - Queremos que las personan paguen algo de ETH para que puedan entrar a la loteria.
     *         1.3 - Hacemos la funcion (payable) así la funcion puede recibir ETH.
     */
    function enterRaffle() external payable {
        if(msg.value < i_entranceFee) revert Raffle_NOT_ENOUGH_ETH();
    }

    function pickWinner() public {}

    /** Getter Functions */
    function getEntranceFee() external view returns(uint256) {
        return i_entranceFee;
    }
}
