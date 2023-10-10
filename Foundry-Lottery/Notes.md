# Lesson 9: 🤩 https://github.com/catherinee24/Foundry-Course-Patrick
Foudry course: FOUNDRY-LOTTERY
``En esta parte del curso vamos a estar desarrollando una loteria con solidity y testeada con Foundry. Aprenderemos muchas cosas interesantes de foundry y buenas practicas a la hora de desarrollar un Proyecto Web3. ``
``rm -rf`` remove -removeforce ---------> Comando para eliminar una carpeta de nuestro path.

## Contrato Inteligente de Sorteo con Aleatoriedad Comprobable. (Proveably Random Raffle Smart Contract)

### Que queremos hacer ? What we want it to do?
1. Los usuarios pueden entrar pagando un Ticket
    1. El fee de los Tickets van a ir al ganador durante el sorteo.
2. Despues de X tiempo, la lotería seleccionará automáticamente a un ganador.
    1. Esto estará hecho programaticamente.
3. Usando Chainlink VRF y Chainlink Automation 
    1. Chainlink VRF ------> Randomness
    2. Chainlink Automation ------> Time based trigger (disparador basado en el tiempo)

## Solidity Contract Layout 

- Version
- imports
- errors
- interfaces, libraries, contracts
- Type declarations
- State variables
- Events
- Modifiers
- Functions

## Layout of Functions:
- constructor
- receive function (if exists)
- fallback function (if exists)
- external
- public
- internal
- private
- internal & private view & pure functions
- external & public view & pure functions

## Custom Errors
Se recomienda hacer ``custom errors`` en vez de ``require`` statement ya que es mas ``gas eficcient`` 
error nombreDelContrato__NombreDelError();

## NatSpec Format
[SOLIDITY DOCS 🫡](https://docs.soliditylang.org/en/v0.8.21/natspec-format.html)
### Para empezar un contrato 

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 < 0.9.0;

/// @title A simulator for trees
/// @author Larry A. Gardner
/// @notice You can use this contract for only the most basic simulation
/// @dev All function calls are currently implemented without side effects
/// @custom:experimental This is an experimental contract.

### Documentar una funcion 
/// @notice Calculate tree age in years, rounded up, for live trees
/// @dev The Alexandr N. Tetearing algorithm could increase precision
/// @param rings The number of rings from dendrochronological sample
/// @return Age in years, rounded up for partial years

## Chainlink VRF
- Chainlink VRF son dos transacciones:
    1. Request the RNG.
    2. Get the random number.


