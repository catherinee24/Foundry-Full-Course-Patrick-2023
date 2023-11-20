// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/**
 * @title OracleLib
 * @author Catherine Maverick from Catellatech.
 * @notice Esta libreria es usada para chequear el Oracle de Chainlink para los datos obsoletos (stale data).
 * Si un precio está obsoleto, las funciones revertirán y harán que el CSCEngine sea inutilizable; esto está
 * diseñado de esta manera.
 * So if the Chainlink network explodes and you have a lot of money locked in the protocol... too bad.
 */
library OracleLib { }
