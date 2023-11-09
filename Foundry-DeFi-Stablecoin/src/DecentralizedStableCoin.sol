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
    error DecentralizedStableCoin__MustBeMoreThanZero();
    error DecentralizedStableCoin_BurnAmountExeedsBalance();

    constructor() ERC20("CatellaUSD", "CSC") { }

    /**
     * @notice La cantidad a quemar debe ser mayor a cero.
     * @notice El balance de la persona que llama debe ser mayor a la cantidad que quiere quemar.
     * @param _amount Cantidad de tokens que se quieren quemar.
     */
    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount <= 0) revert DecentralizedStableCoin__MustBeMoreThanZero();
        if (balance < _amount) revert DecentralizedStableCoin_BurnAmountExeedsBalance();
        super.burn(_amount);
    }
}
