Foundry course: FOUNDRY-DEFI-STABLECOIN
2:09:05

## Testing mientras se desarrolla (Testing)✨
1. Hacemos el **SetUp** de nuestro contrato **CSCEngineTest**. Importamos lo que necesitaremos.
2.  **priceFeed tests**.
    - Queremos asegurarnos de que en la funcion **getUsdValue()** la matemática fuuncione correctamente.
      1.  **function getUsdValue(address _token, uint256 _amount) public view returns (uint256) {}**
      2.  La funcion nos pide la direccion del token y la cantida, asi que para obtenerlo nos ayudamos de nuestro **HelperConfig.sol**
3. **Deposit collateral test** 
    - Queremos verificar que los usuarios puedan depositar su colleteral en el protocolo sin problema.
      1. **function depositCollateral() external {}**
      2. Hacemos una **funcion de test** que revierta si el **usuario quiere depositar el valor de cero (0) como collateral.**
      3. Tenemos que **prankear a un usuario** y Utilizar el **ERC20Mock** de **Openzeppelin**.
      4. aprovamos que el contrato acepte el deposito del collateral del usuario.
      5. hacemos un **expectRevert** con el **custom error** que hicimos en el contrato **CSCEngine.sol** **CSCEngine__NeedsMoreThanZero**.
      6. hacemos la llamada a la funcion **depositCollateral** y depositamos **"0" amount de collateral (weth).**
      7. Paramos el Prank.

    