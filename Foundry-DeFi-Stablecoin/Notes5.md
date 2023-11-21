# continuacion de Notes4.md ✨

//TODO: Llevar el coverage de CSCEngine a 85%

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

- **Desarrollando la librería** **OracleLib.sol**

  - Empezamos creando una función llamada **staleCkeckLatesRoundData()** vamos a tener esta función en **AggregatorV3Interface**
  - Esta funcion tomará como parametro de entrada el **AggregatorV3Interface**.
  - hacemos una variable de estado constante llamada TIMEOUT que guardará los días que tienen que pasar para que se actualice el price feed, que serán 3 dias o 10800 en segundos.

- Ahora lo que podemos hacer ya que esta es una librería es usar la función **staleCkeckLatesRoundData()** para chequear automáticamente si un **precio esta obsoleto.**
- En nuestro CSCEngine en vez de llamar a **latestRoundData()** de **AggregatorV3Interface**, ahora llamaremos a **staleCkeckLatesRoundData()**

## 🎊🎊🎊🎊🎊🎊🎊🎊 COMPLETED LESSON 12 🎊🎊🎊🎊🎊🎊🎊🎊
