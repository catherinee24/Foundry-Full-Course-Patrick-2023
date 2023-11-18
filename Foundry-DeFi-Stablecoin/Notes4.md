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