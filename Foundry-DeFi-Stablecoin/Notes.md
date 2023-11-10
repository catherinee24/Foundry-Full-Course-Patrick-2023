# Lesson 12: Foundry DeFi | Stablecoin (The PINNACLE PROJECT!! GET HERE!) https://github.com/catherinee24/Foundry-Course-Patrick 🤩

1:04:47 
Foundry course: FOUNDRY-DEFI-STABLECOIN

## Arquitectura de nuestra Stablecoin!! ✨

1. (Relative stability): Anchored or Pegged -----> $1.00 USD

   - Haremos codigo para asegurarnos de que nuestra stablecoin siempre valga $1.00.
   - Usaremos **Chainlink** Price feed.
   - Estableceremos una función para intercambiar **BTC** & **ETH** ----> $$$ Cuantos dólares sean.

2. Stability mechanism (Minting): -----> Algorithmic Decentralized.

   - Nuestra stablecoin será decentralizada. No habrá ninguna entidad central que haga el **mint** o **burn**.
   - Será hecho 100% Onchain y algoritmica.
   - Las personas solo pueden mintera la Stablecoin con suficiente colateral.

3. Collateral type: Exogenous (Crypto).
   - Colateral que se orgina desde fuera del protocolo.
   - Usaremos **wBTC** & **wETH** como colateral.

## Contrato DecentralizedStableCoin.sol ✨

- Este contrato será el Token.🪙
- Este contrato no tendrá la logica principal, la lógica estará en otro contrato.
- La función **ERC20Burnable:burn()** de openzeppelin nos ayudará a mantener la estabilidad de nuestra stablecoin.
- El contrato **ERC20Burnable** hereda de **ERC20** por eso lo importamos.
- Como queremos que nuestro token este controlado **100%** por **CSCEngine** contract, Haremos el contrato **DecentralizedStableCoin.sol** Ownable.
- Usamos el contrato **ownable** by **OZ**. Lo que significa que tendremos un **onlyOwner** **modifier**.
- La keyword **super** significa que use la funcion que queramos llamar de la clase padre. En este caso el contrato **ERC20Burnable.sol** de OZ.
   - Ejemplo:
```solidity
 contract DecentralizedStableCoin is ERC20Burnable, Ownable {
   super.burn(_amount);
 }
```
   - La palabra clave **super** en este caso apunta a **ERC20Burnable**.
- Tambien hacemos el **super** porque estamos **sobreescribiendo (override)** la funcion **burn()**.

## Contrato CSCEngine.sol Core contract del sistema CSC (Catellatech StableCoin)✨
- Antes de empezar a codear nuestra logica principal, debemos preguntarnos.. 
- **¿Cúal es la función principal que nuestro contrato debe tener?**
  1. Muchos desarrolladores empienzan por crear **Interfaces**, especificando las funciones que quieren que tenga el proyecto a desarrollar.
- Creamos funciones para que:
  1. Las personas puedan depositar su collateral y mintear CSC (La stablecoin).
  2. Las personas puedan redimir el collateral para CSC.
  3. Las personas puedan quemar Csc.
  4. Las personas pueden ser liquidadas si el valor del collateral (wBTC - wETH) llega a ser menor que CSC, para salvar el protocolo. 
  5. Podamos saber que tan health(Saludables) estan las personas con la posión que tienen abierta en el protocolo.
### Threshold
- "**threshold**" indica un punto específico que debes alcanzar para desbloquear ciertas oportunidades, funciones o beneficios dentro del ecosistema financiero descentralizado.

- Digamos que el threshold es de 150% si un usuario llega a ese % será liquidado.

## Depositar collateral ✨
```soilidty
 function depositCollateral(){}
```
- Hacemos la funcion depositar porque es lo que los usuarios harian principalmente. Depositar su collateral.
   1. Establecemos los parametros, como: la direccion del collateral a depositar y la cantidad de collateral a depositar.
   2. Hicimos un modifier para asegurarnos de que la cantidad de collateral a depositar sea mayor a 0.
   3. Hacimos un modifier para establecer los dos tipos de collateral que se aceptarán (WBT/WETH).
   4. Usamos el **nonReentrant** **modifier** de la libreria de **OZ**, importamos el archivo y lo heredamos. Haciendo eso tenemos acceso al **modifier** **nonReentrant**.
   > ✨ NOTE: Cda vez que estamos trabando con un contrato externo en este caso (los contratos de los tokens collaterales) deberiamos considerar usar el modifier no reentrant en nuestras funciones, para protegernos de posibles vectores de ataque en el proyecto como ---> Reentrancy attack .
   5. Algo que necesitamos hacer es tener una manera de Trackear cuanto collateral alguien está realmente depositando. Para eso creamos un mapping que trackee la cantidad de collatetal depositado.
   6. Cada vez que actualizamos un estado, como los mappings deberiamos de emmitir un evento.
   7. Importamos **IERC20** de **OZ** para poder hacer uso de sus funciones, como, **tranferFrom()**.
