# continuacion de Notes4.md ✨
//TODO: Llevar el coverage de CSCEngine a 85%
Foundry course: FOUNDRY-DEFI-STABLECOIN
4:24:32

## Cosas nuevas que nos enseñará Patrick en lo que resta del curso ✨
- Algunos usos apropiados de oráculos.
- Escribir más test (En realidad lo haré yo 🤌).
- Preparación para una auditora de Smart Contracts.

## OracleLib ✨
En nuestro proyecto estamos usando por supuesto un oráculo, -> (Chainlink Price Feeds). Necesitamos agregar algunos check es nuestro sistema CSCEngine solo para asegurarnos si esto⬆️ rompe o algo dentro de eso rompe, nuestro sistema no este roto. 
- Así que lo que haremos es usar la metodología de librería.
- 📁 Hacemos una carpeta llamada libraries
  - Dentro definimos un **smart contract** llamado **OracleLib.sol** 
  - Lo que vamos a hacer es asegurarnos de que los precios que nos de price feed de chainlink no esten obsoletos o (stales).

- Desarrollando la librería **OracleLib.sol**
  - Empezamos creando una función llamada **stalePriceCheck()** vamos a tener esta función en **AggregatorV3Interface** 
  - Esta funcion tomará como parametro de entrada el **AggregatorV3Interface**.