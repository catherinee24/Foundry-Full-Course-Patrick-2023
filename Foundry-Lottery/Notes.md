# Lesson 9: 🤩 https://github.com/catherinee24/Foundry-Course-Patrick
## Mira el contrato deployado en Sepolia Etherscan --> 0x0EBF272ed1c4223d66a29a12D2Df8cC969938EC6 
6:59:32
Foudry course: FOUNDRY-LOTTERY
`En esta parte del curso vamos a estar desarrollando una loteria con solidity y testeada con Foundry. Aprenderemos muchas cosas interesantes de foundry y buenas practicas a la hora de desarrollar un Proyecto Web3. `
`rm -rf` remove -removeforce ---------> Comando para eliminar una carpeta de nuestro path.

## Contrato Inteligente de Sorteo con Aleatoriedad Comprobable. (Proveably Random Raffle Smart Contract)

### Que queremos hacer ? What we want it to do??

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

Se recomienda hacer `custom errors` en vez de `require` statement ya que es mas `gas eficcient`
error nombreDelContrato\_\_NombreDelError();

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

# Orden en el que vamos a hacer los TEST

1. Unit test
2. integration test
3. forked
4. staging <----- corre un test en mainnet/testnet

## Test & Deploy Script Setup for the Raffle Smart Contract

1. Vamos a escribir algunos scripts de deploy.
2. vamos a escribir nuestro test
   1. Work on a local chain
   2. Forked testnet
   3. Forked Mainnet

## vm.roll and vm.warp (FOUNDRY)

- Foundry Cheatcodes Reference
  [vm.warp](https://book.getfoundry.sh/cheatcodes/warp?highlight=vm.warp#examples): Sets **block.timestamp**.
  [vm.roll](https://book.getfoundry.sh/cheatcodes/roll?highlight=vm.roll#examples): Sets **block.number**.

### openchain.xyz

- En este Link----> https://openchain.xyz/signature copiamos y pegamos una **funcSig** y nos da el nombre de la funcion que estamos llamando.

## Add Consumer Script

- Comando para instalar DevOps de Cyfrin!!

```shell
$ forge install ChainAccelOrg/foundry-devops --no-commit
```

- Comando para tener el total coverage de mis test.

```shell
$ forge coverage --report debug > coverage.txt
```

## vm.expectRevert() con parametros

[FoundryBook](https://book.getfoundry.sh/cheatcodes/expect-revert?highlight=expectRevert#examples).

- Ejemplo: nuestro CustomError con parametros --->

```solidity
error Raffle__UpKeepNotNeeded(uint256 currentBalance, uint256 numPlayers, uint256 raffleState);
```

## Getting event data intro Foundry Scripts

- Vamos a usar un nuevo **cheatcodes** de **Foundry** llamado ----> [recordlogs](https://book.getfoundry.sh/cheatcodes/record-logs?highlight=recordLogs#recordlogs) ----> **vm.recordLogs();**

## Pasando la Private Key a vm.startBroadcast()

**vm.envUint("PRIVATE_KEY")** usamos este cheatcode de Foundry para guardar la private key (FALSA).
!NUCA USES TU PRIVATE KEY REAL, ESTO ES SOLO UN EJEMPLO¡

## Comando para deployar un contrato en la testnet de sepolia
```bash	
$ forge script script/DeployRaffle.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## Comando para debugear 
```bash	
$ forge test --debug $FUNCTION
```

