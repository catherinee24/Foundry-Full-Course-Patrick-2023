# continuacion de InvariantsExplicación.md ✨
//TODO: Llevar el coverage de CSCEngine a 85% 
Foundry course: FOUNDRY-DEFI-STABLECOIN
3:27:18 -

## Open-Based Fuzz (Invariants) Tests ✨
- Creamos dos archivos:
  - Invariants.t.sol
  - Handler.t.sol

### Invariants.t.sol ✨
- Este archivo tendrá nuestras invariantes/ propiedades que el sistema siempre tiene que sostener.
  - **¿Cuales son nuestras invarariantes? /¿Cuales son las propiedades que nuestro sistema debe sostener?**
    1. El supply total de **CSC** **<---(La deuda)** debería ser menor que el valor total del **collateral**.
    2. Las funciones getter view nunca deberian revertir <---- **Evergreen Invariant**(se refiere a condiciones que deberían mantenerse válidas a lo largo de la ejecución del programa o en varias ejecuciones de pruebas).
- **Empezando a desarrollar el contrato:**
  - Importamos el archivo **{ StdInvariant } from "forge-std/StdInvariant.sol"**. Ya que de este vamos a usar varias funciones útiles.
  - Importamos tambien el ya conocido archivo **Test**.
  - Empezamos nuestro contrato definiendo la también conocida **funcion setUp**.

### Handler.t.sol ✨
- El contrato "Handler" va a restringir la manera en que llamamos funciones.
>the contract handler is goin to norrow down the way we call functions