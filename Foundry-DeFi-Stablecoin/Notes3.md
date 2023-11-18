# continuacion de InvariantsExplicación.md ✨
//TODO: Llevar el coverage de CSCEngine a 85% 
Foundry course: FOUNDRY-DEFI-STABLECOIN
3:46:56 -

## Open-Based Fuzz (Invariants) Tests ✨
- Creamos tres archivos:
  - OpenInvariantsTest.t.sol
  - Invariants.t.sol
  - Handler.t.sol

## OpenInvariantsTest.t.sol ✨
- Este archivo tendrá nuestras invariantes/ propiedades que el sistema siempre tiene que sostener.
  - **¿Cuales son nuestras invarariantes? /¿Cuales son las propiedades que nuestro sistema debe sostener?**
    1. El supply total de **CSC** **<---(La deuda)** debería ser menor que el valor total del **collateral**.
    2. Las funciones getter view nunca deberian revertir <---- **Evergreen Invariant**(se refiere a condiciones que deberían mantenerse válidas a lo largo de la ejecución del programa o en varias ejecuciones de pruebas).

- **Empezando a desarrollar el contrato:**
  - Importamos el archivo **{ StdInvariant } from "forge-std/StdInvariant.sol"**. Ya que de este vamos a usar varias funciones útiles.
  - Importamos tambien el ya conocido archivo **Test**.
  - Empezamos nuestro contrato definiendo la también conocida **funcion setUp**. con todos los contratos que necesitaremos, el deployer, token, engine y helperConfig.
  - Dentro del **setUp** usaremos la **función contractTarget()** de **StdInvariant** y colocamos nuestro **CSCEngine** ya que es donde está toda la lógica de nuestro sistema.

- **Empezando a desarrollar las funciones invariantes destro del protocolo:**
  - Las funciones inavariantes se definen con la palabra **invariant_NombreDeLaFuncion()**.
  - Importamos **IERC20** de **openzeppelin** para poder utilizar la **función totalSupply()** y **balanceOf()**. Para así saber cuanto supply hay de **CSC** **Stablecoin** en nuestro **protocolo** y cuanta cantidad de collateral hay depositado **weth/wbt**. 
  - Sabemos que la única manera de mintear **csc** es a través de **CSCEngine** contract.
  - Para obtener el valor en dolares de cada colateral usaremos la funcion de nuestro contrato **CSCEngine:getUsdValue().**

### OpenInvariantsTest.t.sol Falló 👩‍💻
- Comentamos todo el código desarrollado aquí ya que no lo usaremos.
- Lo mejoraremos 😎
- Creamos un nuevo archivo **Invariants.t.sol** y copiamos y pegamos el codigo que habíamos comentado en **OpenInvariantsTest.t.sol**.

## Invariants.t.sol ✨
- Este archivo ultilizará el **Handler.t.sol** contract.
- Queremos asegurarnos de que se llamen a las funciones en un orden con sentido.
  - **Por ejemplo** ----> No llames a la función **redeemCollateral()** al menos que haya collateral para redimir.
  - Por esto creamos **Handler**, para que maneje la forma en la que vamos a llamar funciones en el contrato **CSCEngine.sol** 
  - Y, en vez de que nuestro contrate target sea el CSCEngine va a ser el Handler.
    - **targetContract(address(Handler));**


## Handle-based Fuzz (Invariant) Test setteando el fail_on_revert = true ✨
- El contrato "Handler" va a restringir la manera en que llamamos funciones.
>the contract handler is goin to norrow down the way we call functions
>🤯 En este contrato se hará desarrollo solidity de alto nivel, así que debo practicar esto varias veces!!!
- **Pasos de lo que vamos haciendo para desarrollar este contrato:**
  - Creamos un **constructor** donde vamos a meter el contrato **CSCEngine**, así el **Handler** va a saber qué es ese contrato.
  - Los primeros contratos que importaremos serán el **CSCEngine** y La **StableCoin CSC**, Porque son los contratos que queremos que el **Handler** maneje las llamadas a las funciones. Y lo establecemos en el **constructor()**.
  - Vamos a enfocarnos primero en la función **redeemCollateral()**, Queremos que se llame a esta función solo cuando haya collateral en el protocolo. Por esta razón lo primero que tenemos que hacer es depositar collateral. 
  - La **primera funcion** que creamos será **depositCollateral()** <--- en esta función la **tx** siempre debe ser **True**, no debe revertir.
     - **function depositCollateral(address _collateral, uint256 _amountCollateral) public {}** <-- Esta funcion es en realidad muy similar a un **Fuzz Test**, ya que en nuestros **Handlers** cualquier parametros que tenemos van a ser ramdonizados.
     - La función **depositCollateral()** en realidad fallará, pero lo que **Patrick** quiso enseñarnos, es que a la hora de correr nuestro test de Invariante ---> **invariant_protocolMustHaveMoreValueThanTotalSupply** da como **output lo siguiente**: 
      ```shell
      Test result: FAILED. 0 passed; 1 failed; 0 skipped; finished in 9.84ms
      Ran 1 test suites: 0 tests passed, 1 failed, 0 skipped (1 total tests)

      Failing tests:
      Encountered 1 failing test in test/fuzz/Invariants.t.sol:Invariants
      [FAIL. Reason: Assertion failed.]
              [Sequence]
                      sender=0x0000000000000000000000000000000000000766 addr=[test/fuzz/Handler.t.sol:Handler]0x2e234dae75c793f67a35089c9d99245e1c58470b calldata=depositCollateral(address,uint256), args=[0xe1fD8e7aF45D02D6A4CddF0F372A65CD376101C1, 513974175413903763219376131679322600654750898810425694509908497712322 [5.139e68]]

      invariant_protocolMustHaveMoreValueThanTotalSupply() (runs: 1, calls: 1, reverts: 1)
      ```
      - Si nos fijamos en el output, nos llama la función que escribimos en el **Handler** y no una random. **calldata=depositCollateral(address,uint256)** 
    - Para que nuestra función realmente funcione, en ves de pasar cualquier **address como collateral**, le pasamos como parametro un **uint256**, 
    - **function depositCollateral(uint256 _collateralSeed, uint256 _amountCollateral) public {}**
      - Para completar esta función haremos, una función helper.
        - **function _getCollateralFromSeed(uint256 _collateralSeed) private view returns (ERC20Mock){}**