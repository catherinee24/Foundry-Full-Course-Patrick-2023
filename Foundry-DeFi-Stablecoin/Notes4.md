# continuacion de Notes3.md ✨
//TODO: Llevar el coverage de CSCEngine a 85%
Foundry course: FOUNDRY-DEFI-STABLECOIN
4:07:58

## Handle-based Fuzz (Invariant) Debugging Fuzz Test ✨
- Todavía seguimos teniendo un **Total Supply: 0** ¿Por qué es esto?
```shell
  weth value:  1147469463885807705426121226278000
  wbtc value:  901850094932357595257313670307000
  Total Supply:  0
```
- **¿Cómo nos podemos asegurar que la función mintCsc() en realidad está siendo llamada?**
- 💡Podemos usar algo llamado **Variable Fantasmas**💡