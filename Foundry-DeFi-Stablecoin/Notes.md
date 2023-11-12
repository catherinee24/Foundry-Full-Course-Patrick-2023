# Lesson 12: Foundry DeFi | Stablecoin (The PINNACLE PROJECT!! GET HERE!) https://github.com/catherinee24/Foundry-Course-Patrick 🤩

2:02:23 
Foundry course: FOUNDRY-DEFI-STABLECOIN

## Arquitectura de nuestra Stablecoin!!✨

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
  1.  Establecemos los parametros, como: la direccion del collateral a depositar y la cantidad de collateral a depositar.
  2.  Hicimos un modifier para asegurarnos de que la cantidad de collateral a depositar sea mayor a 0.
  3.  Hacimos un modifier para establecer los dos tipos de collateral que se aceptarán (WBT/WETH).
  4.  Usamos el **nonReentrant** **modifier** de la libreria de **OZ**, importamos el archivo y lo heredamos. Haciendo eso tenemos acceso al **modifier** **nonReentrant**.
      > ✨ NOTE: Cda vez que estamos trabando con un contrato externo en este caso (los contratos de los tokens collaterales) deberiamos considerar usar el modifier no reentrant en nuestras funciones, para protegernos de posibles vectores de ataque en el proyecto como ---> Reentrancy attack .
  5.  Algo que necesitamos hacer es tener una manera de Trackear cuanto collateral alguien está realmente depositando. Para eso creamos un mapping que trackee la cantidad de collatetal depositado.
  6.  Cada vez que actualizamos un estado, como los mappings deberiamos de emmitir un evento.
  7.  Importamos **IERC20** de **OZ** para poder hacer uso de sus funciones, como, **tranferFrom()**.

## Mitear CSC Obteniendo el valor de nuestro collateral✨

```solidity
function mintCsc() external {}
```

- Hacemos la funcion **mintCsc()** para que los usuarios puedan mintear la stablecoin seguan la cantidad de collateral que depositaron. Para poder mintear CSC tenemos que:
  1.  Checkear que el **valor del collateral** sea **mayor que** el **valor de CSC (Catella StableCoin)**.
  2.  Necesitamos mantener trackeado la cantidad de CSC que el usuario está minteando. para ello creamos un mapping.
  3.  Checkeamos que la funcion revierta si el usuario quiere mintar más CSC que el collateral que está depositando. ($150 CSC, $100 ETH). Para esto creamos una funcion interna.
      - **\_revertIfHealthFactorIsBroken(msg.sender)** - En esta funcion checkeamos el **health factor(Se tiene que tener suficiente collateral).**  
         - Revierte si no se tiene un buen health factor. - Para usar esta funcion tenemos que crear otra llamada: - **\_healthFactor(address \_user)** - Para resolver esta funcion necesitamos el **total minteado de CSC.** - **VALOR total del collateral**.
        > ✨NOTE: El ETH(collateral) siempre tiene que ser mayor a CSC.
  4.  Hicimos varias **funciones internas view** para usarlas en las funciones **externas**, como:
      - **function \_getAccountInformation(address \_user){}**
      - **function \_healthFactor(address \_user) private view returns (uint256) {}**
      - **function \_revertIfHealthFactorIsBroken(address \_user) internal view {}**

## Testing mientras desarrollamos (Deploy Script) ✨

1. Para deployar el contrato **CSCEngine**, hicimos un **archivo Script HelperConfig**, para poder obterner las **Addresses** que pide el constuctor del **CSCEngine.sol**
  - **constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address cscAddress){}**

### Helper config Script 
- Creamos un **struct** llamado **NetworkConfig** y definimos los campos que necesitamos para deployar el contrato **CSCEngine**.
```solidity
    struct NetworkConfig {
        address wethUsdPriceFeed;
        address wbtcUsdPriceFeed;
        address weth;
        address wbtc;
        uint256 deployerKey;
    }
```
- Usamos el cheatcode de **Foundry vm.envUint** `deployerKey: vm.envUint("PRIVATE_KEY")`.
- Necesitamos **Mocks** para probar de manera "**falsa**" (ANVIL) el funcionamiento del proyecto.
   - **MOCKS IS FOR TESTING PURPOSE**
   - Utilizamos el **MockV3Aggregator** de **Chainlink** para el **price feed**.
   - Utilizamos el **ERC20Mock** de **openzeppelin** para los **token ERC20. (wBTC/wETH)**.

2. Como nuestro contrato **DecentrilizedStableCoin.sol** es **OWNABLE**, pero necesitamos que sea propiedad de **CSCEngine.sol**, tenemos que usar la funcion **Ownable:tranferOwnership()** para tranferir el ownership al contrato **CSCEngine.sol**.

## Chainlink Price Feed ✨
- Un price feed de Chainlink es como un servicio que proporciona información en tiempo real sobre los precios de activos digitales, como Bitcoin o Ethereum, en relación con monedas fiduciarias como el dólar estadounidense. Imagina que es como un marcador en un juego que muestra constantemente el precio actual de estas criptomonedas.
- BTC/USD , ETH/USD
