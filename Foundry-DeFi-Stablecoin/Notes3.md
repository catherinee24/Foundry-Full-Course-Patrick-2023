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

### Handler.t.sol ✨
- El contrato "Handler" va a restringir la manera en que llamamos funciones.
>the contract handler is goin to norrow down the way we call functions