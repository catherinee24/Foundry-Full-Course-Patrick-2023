# continuacion de Notes3.md ✨
//TODO: Llevar el coverage de CSCEngine a 85%
Foundry course: FOUNDRY-DEFI-STABLECOIN
4:24:32

## Handler Ghost Variables ✨
Dentro de los Handlers, se pueden seguir las **"variables fantasma"** a lo largo de varias llamadas de funciones para agregar información adicional para pruebas de invariantes. 
Un buen ejemplo de esto es sumar todas las participaciones que cada proveedor de liquidez (LP) posee después de depositar en el token ERC-4626, como se muestra arriba, y usar eso en el invariante (totalSupply == sumBalanceOf).

## Handle-based Fuzz (Invariant) Debugging Fuzz Test ✨
- Todavía seguimos teniendo un **Total Supply: 0** ¿Por qué es esto?
```shell
  weth value:  1147469463885807705426121226278000
  wbtc value:  901850094932357595257313670307000
  Total Supply:  0
```
- **¿Cómo nos podemos asegurar que la función mintCsc() en realidad está siendo llamada?**
- 💡Podemos usar algo llamado **Variable Fantasmas**💡
> ✨https://book.getfoundry.sh/forge/invariant-testing?highlight=gosht%20variables#handler-ghost-variables Link de Foundry Book.

- **Desarrollando el Handler con variables fantasmas:**
  - Definimos una variable de estado llamada **timesMintIsCalled**.
  - Luego la establecemos en la funcion **mintCsc()** en la ultima linea y la incrementamos. 
      - -> **timesMintIsCalled++;**
  - Luego en el contrato **Invariants.sol** hacemos un console.log() llamando a esa variable. 
      - -> **console.log("Times mint is called: ", handler.timesMintIsCalled());**

- Corremos el **test invariante** despues de agregar el **console log Times mint is called** y esta fue la salida:
```shell
  weth value:  1369980371217743304605780316394000
  wbtc value:  730888063435560163236226977123000
  Total Supply:  0
  Times mint is called:  0
```
- Vemos que **Times mint is called: 0** lo que significa que la función nunca se está llamando.
- 🤯**¿Por qué es esto posible?** : Debe ser porque uno de los **returns** establecidos en la funcion **mintCsc** está activando y comenzando a finalizar esta llamada. Y por está razón nunca llega a llamar **TimesMintIsCalled++;**

- **Hay dos maneras de debbuggear esto:** 
  1. Una es hacer **TimesMintIsCalled+=1;** y moverla a la linea donde está rompiendo.
     - Al hacer esto y correr nuevamente el test, **este es el output:**
```shell
  weth value:  628318170818635033511474243616000
  wbtc value:  410030903666268532509776962402000
  Total Supply:  0
  Times mint is called:  33
```
- 🤯Podemos observar que ahora nuestro **Times mint is called: 33** aumentó, lo que significa que no se está rompiendo y si se está llamando la función **mintCsc()**   
  2. La otra manera de que la función **mintCsc()** sea llamada es:
     - -> Mantener el siguimiento de las personas que hayan **depositado collateral** **depositCollateral()** y luego vamos a la función **mintCsc()** que elige una dirección de alguien que ya haya depositado collateral.
     - **¿Cómo podemos hacer esto?**

- Con un array de addresses podemos mantener traqueado las cuentas que hayan depositado collateral.
  - Creamos una variable de array de addresses llamada: **address[] public usersWithCollateralDeposited;**
  - Esta variable la establecemos en la **función depositCollateral()**
  - Pusheamos el msg.sender al array: **usersWithCollateralDeposited.push(msg.sender);**

- Y ahora en la función **mintCsc()** hacemos algo similar que en la función **redeemCollateral()**:
  - Le pasamos otro parametro de entrada llamado **_addressSeed** que será un **intiger sin signo (uint256)**.
  - Creamos una variable local de tipo address llamado **msgSender** que guardará el _addressSeed % el length de los usuarios que han depositado collateral (usersWithCollateralDeposited.length).
  - Y esta variable **msgSender** la usaremos en vez de el **msg.sender** que hemos estado usando.
  
- Despues de Implementar este nuevo array de addressess **usersWithCollateralDeposited** Corremos nuevamente el **test de invariante** y el output es el siguiente:
```shell
  Bound Result 1
  weth value:  1867559056286543309640817713424000
  wbtc value:  547375458383624690028499181681000
  Total Supply:  258512600724431530044849647329644
  Times mint is called:  23
```
- 🤯Podemos observar que nuevamente nuestro **Times mint is called: 23** aumentó, lo que significa que no se está rompiendo y si se está llamando la función **mintCsc()**. 

## 2. Las funciones getter view nunca deberian revertir 
## Creando una nueva función en el contrato Invariant.t.sol ✨
- Creamos una nueva **función public view** llamada -> **function invariant_gettersShouldNotRevert() public {}**
- Dentro definimos todas nuestras funsiones getters -> **cscEngine.getPrecision()** y el resto .....
> TIP 💡: escribiendo este comando en la consola -> $ forge inspect CSCEngine methods Nos aparecerán todas las funciones que están definidas en nuestro contrato CSCEngine ✨

## Price Feed Handling ✨
- 💡Una de las otras cosas fantásticas que podemos hacer con el **handler** es.. manejamos el contrato CSCEngine, pero tambien podemos hacerlo con otro contrato que queramos. Para simular también💡
- Hay muchas cosas que tenemos que mantener en mente cuando escribimos esto, especialmente el otro contrato con el que vamos a interactuar.
- **¿Cúales son los otros contratos con los que vamos a interactuar?** 
  - Price Feed contract
  - WETH Token
  - WBTC Token
- Así que nuestro **handler** probablemente debería mostrar, a la gente haciendo cosas randoms con los tokens. Porque las personas seguramente harán cosas aleatorias con los tokens y necesitamos que el protocolo maneje todo apropiadamente.
- Por ahora nos centraremos en el **PRICE FEED** por que es un sistema que definitivamente puede cambiar y es un sistema que realmente tiene un gran efecto en nuestro protocolo.
- Así que vamos a incluir **actualizaciones de price feeds** en nuestro **handler**. 

- **Empezando con el desarrollo del **PRICE FEED** en el handler.sol** ✨
  - 📁 Primero importamos el archivo **MockV3Aggregator.sol**
  - Este archivo tiene una función que queremos usar que es **updateAnswer()** queremos que nuestro protocolo pueda actualizar precios facilmente.
  - En el **constructor del handler** pondremos la función que creamos en **cscEngine -> getCollateralTokenPriceFeed** y le pasamos el token collateral, **weth/wbtc**. 
- Ahora vamos a agregar una nueva función en nuestro handler:
  - **UpdateCollateralPrice()** -> está función tomará como parametro de entrada un **uint96 newPrice**
  - Necesitamos convertir el **uint96** en **int256** porque la función **updateAnswer()** que llamaremos del **MockV3Aggregator.sol** toma como parametro de entrada un **int256**:
    - **function updateAnswer(int256 _answer) public {}**
- Ahora podemos hacer 4 cosas en nuestro sistema,
  - Podemos actualizar el precio de los collaterales a usd.
  - Redimir collateral.
  - Depositar collaterale.
  - Mintear CSC token.
- Algo que nos tenemos que preguntar es que hacer si el precio del collateral se desploma en un solo bloque. Ahora mismo tenemos un tipo de assertions en **CSCEngine**, tenemos -> **LIQUIDATION_BONUS** y el collateral tiene que estar 200% overcollateralized -> **LIQUIDATION_THRESHOLD**. Con esto estamos diciendo:
  - Ok, entre **200% <-> 110%** de **sobre colateralizacion**, nuestro sistema está aun a salvo. 
> 💔 La funcion UpdateCollateralPrice() de nuestro handler, rompe nuestra suite de prubas de invariantes.💔 
