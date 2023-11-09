# Lesson 12: Foundry DeFi | Stablecoin (The PINNACLE PROJECT!! GET HERE!) https://github.com/catherinee24/Foundry-Course-Patrick 🤩

49:48
Foundry course: FOUNDRY-DEFI-STABLECOIN

## Arquitectura de nuestra Stablecoin!! ✨

1. (Relative stability): Anchored or Pegged -----> $1.00 USD

   - Haremos codigo para asegurarnos de que nuestra stablecoin siempre valga $1.00.
   - Usaremos **Chainlink** Price feed.
   - Establecemos una función para intercambiar **BTC** & **ETH** ----> $$$ Cuantos dólares sean.

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
