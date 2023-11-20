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

    /**
     * Retorna el latestRoundData() de AggregatorV3Interface
     * @return roundId
     * @return answer
     * @return startedAt
     * @return updatedAt
     * @return answeredInRound
     */
    function stalePriceCheck(AggregatorV3Interface priceFeed)
        public
        view
        returns (uint80, int256, uint256, uint256, uint80){}
}
