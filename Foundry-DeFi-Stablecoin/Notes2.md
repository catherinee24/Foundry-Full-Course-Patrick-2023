Foundry course: FOUNDRY-DEFI-STABLECOIN
2:09:05

## Testing mientras se desarrolla (Testing)✨
1. Hacemos el **SetUp** de nuestro contrato **CSCEngineTest**. Importamos lo que necesitaremos.
2. Uno de los primeros test que vamos a hacer es el **priceFeed tests**.
    - Queremos asegurarnos de que en la funcion **getUsdValue()** la matemática fuuncione correctamente.
      1.  **function getUsdValue(address _token, uint256 _amount) public view returns (uint256) {}**
      2.  La funcion nos pide la direccion del token y la cantida, asi que para obtenerlo nos ayudamos de nuestro **HelperConfig.sol**

    