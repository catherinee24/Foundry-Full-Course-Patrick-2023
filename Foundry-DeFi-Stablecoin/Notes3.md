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


## Handle-based Fuzz (Invariant) Test setteando el fail_on_revert = true ✨
- El contrato "Handler" va a restringir la manera en que llamamos funciones.
>the contract handler is goin to norrow down the way we call functions

