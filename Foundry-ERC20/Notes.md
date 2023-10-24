# Lesson 10: Foundry ERC20s https://github.com/catherinee24/Foundry-Course-Patrick 🤩

## Contract Address del Token que creamos 🫡
0x8161547892A4ee217b89f25dbB560A1A89D26369
7:25:40 

Foudry course: FOUNDRY-ERC20
## Qué es ERCs y un EIPs???
* EIPs ------> **(Ethereum Improvement Proposals)** Es una estructura documental que permite estandarizar el desarrollo de mejoras dentro de Ethereum, permitiendo que cualquier persona pueda presentar sus propuestas y mejorar así el desarrollo de esta blockchain. 

* ERCs ------> **(Ethereum Request for Comment)** Es un protocolo para proponer y estandarizar nuevos token y estándares de contrato inteligentes en la cadena de bloques Ethereum. Los **ERC** son similares a los **EIP** en el sentido de que son cambios propuestos al ecosistema Ethereum, pero los **ERC** se centran específicamente en definir nuevos token y estándares de contratos inteligentes.

Los **ERC** definen las reglas y especificaciones para crear nuevos tokens o contratos inteligentes que se pueden usar en la cadena de bloques Ethereum. Esto incluye el **nombre del token**, el **símbolo**, los **decimales** y el **suministro total**. Los desarrolladores suelen proponer los **ERC**, pero cualquier persona en la comunidad de **Ethereum** también puede proponerlos.

## Enlance para ver las espicificaciones y funciones de un ERC-20
[ethereum.org](https://eips.ethereum.org/EIPS/eip-20)

### Comando para instalar los contratos de OZ 
```bash
$ forge install OpenZeppelin/openzeppelin-contracts --no-commit
```

### Comando para deployar el contrato 
```bash
$ forge script script/DeployRaffle.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## Finished Lesson I´m proud of Myself 😊