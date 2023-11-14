# Continuación de Notes2.md ✨
Foundry course: FOUNDRY-DEFI-STABLECOIN
2:54:14

## Subiendo de nivel nuestras habilidades de Testing ✨
- Creamos un **test** para probar que funcione correctamente el **Constructor** del contrato **CSCEngine.sol**.
- Testeamos la funcion **getTokenAmountFromUsd()** e hicimos lo opuesto al test **testGetUsdValue()**.
- Testeamos el **modifier isAllowedToken** con el nombre **testRevertsWithUnapprovedCollateral()** 
    - Creamos  un nuevo token con el **ER20Mock de openzeppelin**.
    - Empezamos un **prank con un USER** y ese token lo depositamos en el protocolo.
    - Va a fallar por que los unicos tokens permitidos como collateral son weth y wbtc.