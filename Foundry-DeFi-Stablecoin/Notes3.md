# Continuación de Notes2.md ✨
//TODO: Llevar el coverage de CSCEngine a 85% 
Foundry course: FOUNDRY-DEFI-STABLECOIN
3:13:41

## Subiendo de nivel nuestras habilidades de Testing ✨
### Fuzz (Invariant) Testing ✨
1. ¿Cúales son nuestras invariantes/propiedades de nuestro sistema?

### Fuuz Testing: 
El fuzz testing es una técnica de prueba de software que se centra en la introducción de datos de entrada aleatorios para exponer errores y vulnerabilidades. Su enfoque no determinista y su capacidad para encontrar problemas inesperados hacen que sea una herramienta valiosa en el proceso de aseguramiento de la calidad del software.
- **Ejemplo**:
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract MyContract {
    uint256 public shouldAlwaysBeZero = 0;
    uint256 private hiddenValue = 0;

    function doStuff(uint256 data) public {
        if (data == 2) {
            shouldAlwaysBeZero = 1;
        }
        if (hiddenValue == 7){
            shouldAlwaysBeZero = 1;
        }
        hiddenValue = data;
    }
}
```
- En este ejemplo la variable **shouldAlwaysBeZero** la podemos calificar como nuestra invariante.
  - **Invariante**: Propiedad de nuestro sistema que deberia ser siempre sostenido.
- Esta invariante nunca se puede romper en nuestro código.

### Tips para entender un poco más fuzz/invariants ✨
1. Entender las **invariantes** o **propiedades** que un sistema siempre debe sostener.
2. Escribir un test de fuzzing para las invariantes, para tratar de romper esa invariantes.

### Stateless fuzzing:🤯
- Donde el estado de la ejecución anterior se descarta para cada nueva ejecución.