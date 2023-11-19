# continuacion de Notes3.md ✨
//TODO: Llevar el coverage de CSCEngine a 85%
Foundry course: FOUNDRY-DEFI-STABLECOIN
4:07:58

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
