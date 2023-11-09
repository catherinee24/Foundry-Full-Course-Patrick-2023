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
    error DecentralizedStableCoin__BurnAmountExeedsBalance();
    error DecentralizedStableCoin__NotAddressZero();
    error DecentralizedStableCoin__AmountMustBeGreaterThanZero();

    constructor() ERC20("CatellaUSD", "CSC") { }

    /**
     * @notice Funcion burn(): Diseñada para permitir que el propietario del contrato (CSCEnginee) queme una cierta
     * cantidad de tokens, siempre y cuando cumpla con las verificaciones de límite y tenga suficientes tokens en su
     * saldo.
     * @dev if() statement 1: Verifica si la cantidad que se quiere quemar es menor o igual a cero. Si es así, revierte la transacción
     * con un mensaje de error indicando que la cantidad debe ser mayor que cero.
     * @dev if() statement 2: Verifica si la cantidad que se quiere quemar es mayor que el saldo disponible en la cuenta del
     * propietario. Si es así, revierte la transacción con un mensaje de error indicando que la cantidad a quemar
     * excede el saldo.
     * @param _amount Cantidad de tokens que se quieren quemar.
     */
    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount <= 0) revert DecentralizedStableCoin__MustBeMoreThanZero();
        if (balance < _amount) revert DecentralizedStableCoin__BurnAmountExeedsBalance();
        super.burn(_amount);
    }

    /**
     * @notice El balance de la persona que llama debe ser mayor a la cantidad que quiere quemar.
     * @param _to Dirección a la cual se van a enviar las nuevas unidades de Token creados.
     * @param _amount Cantidad de nuevas unidades de Tokens que se van a crear y enviar a la dirección especificada en
     * "_to".
     */
    function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
        if(_to == address(0)) revert DecentralizedStableCoin__NotAddressZero();
        if(_amount <= 0) revert DecentralizedStableCoin__AmountMustBeGreaterThanZero();
        _mint(_to, _amount);
        return true;
    }
}
