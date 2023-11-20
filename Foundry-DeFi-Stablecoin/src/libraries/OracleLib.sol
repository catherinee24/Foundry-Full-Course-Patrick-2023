// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
/**
 * @title OracleLib
 * @author Catherine Maverick from Catellatech.
 * @notice Esta libreria es usada para chequear el Oracle de Chainlink para los datos obsoletos (stale data).
 * Si un precio está obsoleto, las funciones revertirán y harán que el CSCEngine sea inutilizable; esto está
 * diseñado de esta manera.
 * Queremos que el DSCEngine se bloquee si los precios se vuelven obsoletos.
 * So if the Chainlink network explodes and you have a lot of money locked in the protocol... too bad.
 */

library OracleLib {
    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    ERRORS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    error OracleLib__StalePrice();

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                CONSTANT VARIABLES 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    uint256 private constant TIMEOUT = 3 hours; // 3 * 60 * 60 = 10800 seconds

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    FUNCTIONS 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    /**
     * @notice Esta función parece diseñada para garantizar que los datos proporcionados por el oráculo no sean
     * demasiado antiguos para ser considerados válidos.
     * @notice Calcula la cantidad de segundos transcurridos desde la última actualización del oráculo
     * @notice Comprueba si el tiempo transcurrido (secondsSince) desde la última actualización del oráculo supera un
     * límite predefinido (TIMEOUT). Si ha pasado demasiado tiempo desde la última actualización, se revierte la
     * transacción
     * @param priceFeed esta función espera un contrato que cumpla con la interfaz AggregatorV3Interface
     * como un servicio de precios.
     * @notice La función devuelve varios valores relacionados con el latestRoundData() del oráculo, que incluyen:
     * @return roundId
     * @return answer
     * @return startedAt
     * @return updatedAt
     * @return answeredInRound
     */

    function staleCkeckLatestRoundData(AggregatorV3Interface priceFeed)
        public
        view
        returns (uint80, int256, uint256, uint256, uint80)
    {
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) =
            priceFeed.latestRoundData();

        uint256 secondsSince = block.timestamp - updatedAt;
        if (secondsSince > TIMEOUT) revert OracleLib__StalePrice();
        return (roundId, answer, startedAt, updatedAt, answeredInRound);
    }

    function getTimeout(AggregatorV3Interface /* chainlinkFeed */ ) public pure returns (uint256) {
        return TIMEOUT;
    }
}
