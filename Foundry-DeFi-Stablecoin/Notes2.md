# Continuación de Notes.md ✨
Foundry course: FOUNDRY-DEFI-STABLECOIN
2:09:05

## Testing mientras se desarrolla (Testing)✨
### priceFeed tests 👩‍💻
1. Hacemos el **SetUp** de nuestro contrato **CSCEngineTest**. Importamos lo que necesitaremos.
2.  **priceFeed tests**.
    - Queremos asegurarnos de que en la funcion **getUsdValue()** la matemática fuuncione correctamente.
      1.  **function getUsdValue(address _token, uint256 _amount) public view returns (uint256) {}**
      2.  La funcion nos pide la direccion del token y la cantida, asi que para obtenerlo nos ayudamos de nuestro **HelperConfig.sol**

### Deposit collateral test 👩‍💻
  - Queremos verificar que los usuarios puedan depositar su colleteral en el protocolo sin problema.
      1. **function depositCollateral() external {}**
      2. Hacemos una **funcion de test** que revierta si el **usuario quiere depositar el valor de cero (0) como collateral.**
      3. Tenemos que **prankear a un usuario** y Utilizar el **ERC20Mock** de **Openzeppelin**.
      4. aprovamos que el contrato acepte el deposito del collateral del usuario.
      5. hacemos un **expectRevert** con el **custom error** que hicimos en el contrato **CSCEngine.sol** **CSCEngine__NeedsMoreThanZero**.
      6. hacemos la llamada a la funcion **depositCollateral** y depositamos **"0" amount de collateral (weth).**
      7. En el **setUp** le **minteamos** el **token weth al USER** a traves del **ERC20Mock**.
      8. Paramos el Prank.

> ✨NOTE✨: Hicimos en la consola $ forge test --fork-url $SEPOLIA_RPC_URL y falló porque no podemos solo Mintear weth y en la funcion getUsdValue estamos hardcodeando el expectedUsd, y por supuesto el precio en SEPOLIA es el precio actual. Así que probablemente debemos actualizar nuestro TEST y hacerlo más agnóstico.

> ✨Curious✨: "agnóstico" significa ser independiente o compatible con múltiples plataformas, sistemas o entornos sin estar restringido a uno en particular.

## DepositCollateralAndMintCSC function ✨
- Vamos a combinar las funciones **CSCEngine:depositCollatera()** y **CSCEngine:mintCSC()** dentro de una sola funcion **CSCEngine:depositCollateralAndMintCSC()**
- El propósito de esta funcion es mintear CSC StableCoin.
- Como la función **depositCollateral()** estaba **external**, la hicimos **publica** para poderla usar dentro del contrato.
- Igualmente hicimos con la función **mintCsc() ------> public now**.

## redeemCollateral function ✨
- Ok ya que tenemos una manera de **depositar** el dinero en el protocolo, tenemos que tener una manera de **retirarlo**. 
- Pare eso desarrollaremos la función **redeemCollateral()**
- usamos el **modifier moreThanZero(amoun)** por que no queremos que haya ninguna transaccion con 0 value.
- usamos el **nonReentrant modifier** porque vamos a estar moviendo Tokens. 
- Para poder redimir el collateral:
  1. El factor de salud (Health Factor) debe ser 1 DESPUÉS de retirar el colateral. 

## burnCSC function ✨
- Actualizamos el **mapping s_CSCMinted** reduciendo la cantidad de csc stableCoin que se quieren quemar. 
- hacemos la interacción para que el usuario deposite **"por ahora"** los **csc stableCoin** al contrato **CSCEngine**.
- ¿Necesitamos chequear el breaks health factor en esta función?
  - Probablemente No, porque si estamos quemando **CSC** estamos quemando **deuda**, es casi poco probable (unlikely) que se rompa el **health factor**. 
  - Pero lo agregaremos por ahora.
- Hacemos la función **publica** por que la vamos a combinar con otra función ---> **redeemCollateralForCSC()** y la necesitamos llamar dentro del contrato.
> ✨NOTE✨ MÁS ADELANTE VAMOS A REFACTORIZAR MUCHAS DE ESTAS FUNCIONES!!!!!!!!!!!!!!!!!!!!!! 

## Liqudate (SETUP) ✨
- La función **liquidate()** es una de la más importante para el funcionamiento correcto del proyecto. ‼️‼️‼️
>✨Recuerda✨: El protocolo nunca puede estar undercolateralizado, al contrario siempre debe estar sobrecolateralizado. Es decir tener más collateral.
- Si nos acercamos a una **subgarantía (Undercollateralization)**, necesitamos que alguien **liquíde posiciones**.
- Si alguien está casi **undercollateralizado**, **te pagaremos para que lo liquídez**.
- **Pasos que seguimos para hacer la función:**
  1. Pasamos los parametros correspondientes para el funcionamiento de la función como: 
     - la direccion del token
     - la direccion del usuario que vamos a liiquidar  
     - la cantidad de deuda que el liquidador pagará.
  2. usamos los modifiers moreThanZero(deuda a pagar) y nonReentrant ya que vamos a mover tokens. 
  3. Esta función tambien sigue el patrón CEI.
  4. Hacemos una variable dentro de la funcion que guarde el health factor inicial del usuario.
  5. chequeamos que el health factor inicial del usuario sea mayor o igual al Minimo health factor que es 1e18.
- En esta funcion queremos quemar los CSC StableCoin (deuda) de los usuarios y tomar su collateral (weth o wbtc).
> 👩‍💻BAD USER👩‍💻: $140 ETH, $100 CSC
> debtToCover: $100 
> $100 of CSC == ??? ETH 