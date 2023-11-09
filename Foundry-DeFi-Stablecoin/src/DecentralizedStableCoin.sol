// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { ERC20Burnable, ERC20 } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/// @title DecentralizedStableCoin
/// @author Catherine Maverick
/// @notice This is the contract meant to be governed by the CSCEngine contract. This contract is just the    ERC-20
/// implementation of our stablecoin system.
/// @dev Collateral: Exogenous (ETH & BTC)
/// @dev Relative Stability: Pegged to USD

contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    constructor() ERC20("CatellaUSD", "CSC") { }
}
