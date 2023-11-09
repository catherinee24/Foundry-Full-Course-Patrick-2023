// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { ERC20Burnable, ERC20 } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/// @title DecentralizedStableCoin
/// @author Catherine Maverick from catellatech.
/// @notice This is the contract meant to be governed by the CSCEngine contract. This contract is just the    ERC-20 implementation of our stablecoin system.
/// @dev Collateral: Exogenous (ETH & BTC)
/// @dev Relative Stability: Pegged to USD

contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/
    error DecentralizedStableCoin__MustBeMoreThanZero();
    error DecentralizedStableCoin__BurnAmountExeedsBalance();
    error DecentralizedStableCoin__NotAddressZero();
    error DecentralizedStableCoin__AmountMustBeGreaterThanZero();

    constructor() ERC20("CatellaUSD", "CSC") Ownable(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) { }

    /**
     * @notice Funcion burn(): Diseñada para permitir que el propietario del contrato (CSCEnginee) queme una cierta cantidad de tokens, siempre y cuando cumpla con las verificaciones de límite y tenga suficientes tokens en su saldo.
     * @dev if() statement 1: Verifica si la cantidad que se quiere quemar es menor o igual a cero. Si es así, revierte la transacción con un mensaje de error indicando que la cantidad debe ser mayor que cero.
     * @dev if() statement 2: Verifica si la cantidad que se quiere quemar es mayor que el saldo disponible en la cuenta del propietario. Si es así, revierte la transacción con un mensaje de error indicando que la cantidad a quema excede el saldo.
     * @param _amount Cantidad de tokens que se quieren quemar.
     */
    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount <= 0) revert DecentralizedStableCoin__MustBeMoreThanZero();
        if (balance < _amount) revert DecentralizedStableCoin__BurnAmountExeedsBalance();
        super.burn(_amount);
    }

    /**
     * @notice Funcion mint(): Diseñada para permitir que el propietario del contrato (CSCEnginee) cree nuevas unidades de tokens y las asigne a una dirección específica, siempre y cuando se cumplan las condiciones de validación.
     * @dev if() statement 1: Verifica si la dirección de destino (_to) es la dirección 0. Revierte la transacción si es así, con un mensaje de error indicando que la dirección no puede ser la dirección 0.
     * @dev if() statement 2: Verifica si la cantidad de tokens que se quiere crear y asignar es menor o igual a cero. Revierte la transacción si es así, con un mensaje de error indicando que la cantidad debe ser mayor que cero.
     * @param _amount Cantidad de nuevas unidades de Tokens que se van a crear y enviar a la dirección especificada en "_to".
     * @param _to Dirección a la cual se van a enviar las nuevas unidades de tokens creadas.
     * @return Devuelve true para indicar que la operación de minting fue exitosa.
     */
    function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
        if (_to == address(0)) revert DecentralizedStableCoin__NotAddressZero();
        if (_amount <= 0) revert DecentralizedStableCoin__AmountMustBeGreaterThanZero();
        _mint(_to, _amount);
        return true;
    }
}
