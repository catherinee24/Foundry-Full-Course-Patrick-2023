# Lesson 7: 🤩 https://github.com/catherinee24/Foundry-Course-Patrick

## Dependencies

Para descargar los paquetes de chainlink.

```shell
$ forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit
```

Para rodar un test en especifico y no todos.

```shell
$ forge test --match-test testPriceFeedVersionIsAccurate
```

Para hacer Forked test.

```shell
$ forge test --match-test testPriceFeedVersionIsAccurate --fork-url $SEPOLIA_RPC_URL
```

Para ver que tanto está testeado el proyecto.

```shell
$ forge coverage --fork-url $**SEPOLIA_RPC_URL**
```

## Archivo Helper Config

Hicimos un archicvo en Script llamado `HelperConfig` para utilizar de manera automatica las networks que estemos usando, ya sea Testnet como SEPOLIA o Mainnet como ETHEREUM.

## Mocks

Un contrato Mock es basicamente un contrato falso que vamos a estar usando en el script de ``helper config`` en la funcion de ``Anvil``.
``Los Mocks los creamos en la carpeta de tests.``

## Magic Numbers

``Evitar tener magic numbers en funciones``. Es mejor pratica hacer variables constantes.

## Foundry Cheatcodes

Podemos encontrar todos los cheatcodes que fondry propociona en su pag.
https://book.getfoundry.sh/cheatcodes/expect-revert

En el curso vimos unos cuantos como:

- `vm.expectRevert();`: Espera revertir la funcion que estemos testeado.
- `vm.prank();`: crea un usuario para saber que empieza un TX.
- `vm.makeAddr();`: crea el address de un usuario.
- `vm.deal();`: fondeamos dinero a un address.
- `hoax();`: Creamos y fondeamos multiples addresses.
- `vm.txGasPrice;`: Creamos y fondeamos multiples addresses.

## Std cheats codes HOAX

https://book.getfoundry.sh/reference/forge-std/hoax

- Descripción
  Establece un prank de una dirección que tiene algo de éter.

## Modifiers en los Test

Creamos modifiers en los test para no repetir lineas de codigo y mantener el contrato de test limpio y leible a medida que testeamos mas y mas funciones.

## Metodologias para trabajar con test

Cada vez que trabajemos con un test siempre vamos a pensar en este ``patron``:

    1. Arrange : Setup the test.
    2. Act: hacemos la accion que queremos testear.
    3. Assert: hacemos el assert del test.
Ejemplo:
```solidity
function testWithdrawWithASingleFunded() external funded {
        //Arrenge
        // Empezamos viendo cuanto es el balance del Owner y del contrato FundMe antes de hacer la TX.
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        // fundMe.getOwner() por que solo el owner puede llamar a esta funcion.
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        // Nos aseguramos de que hayamos retirado todo el dinero del contrato FundMe.
        assertEq(endingFundMeBalance, 0);
        assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
    }
```

## Para Crear addresses

usamos ``uint160`` ya que tiene la misma cantidad de bytes que un address.

## Foundry Chisel

Chisel nos permite escribir codigo solidity en nuestra terminal y ejecutarlo linea por linea.

Para ejecutar chisel en la consola.

```shell
$ chisel
➜ uint256 cat = 1;
➜ cat
Type: uint
├ Hex: 0x1
└ Decimal: 1
➜
```

`Ctrl + c` ----> para salir de la terminal de Chisel.

## Gas: cheaper in test withdraw

Si queremos hacer mas barato un test podemos hacer lo siguiente:

```shell
$ forge snapshot --match-test testWithdrawFromMultipleFunders
```

Eate comando nos creara un archivo llamado `.gas-snapshot`. Dentro del archivo encotraremos una informacion asi:

```
FundMeTest:testWithdrawFromMultipleFunders() (gas: 487922)
```

El gas en anvil viene por defecto a cero(0), pero cuando queremos testear de manera real cuanto gas gastamos, podemos usar el siguiente cheatcode de foundry:

### txGasPrice

- https://book.getfoundry.sh/cheatcodes/tx-gas-price?highlight=txGas#txgasprice

`vm.txGasPrice(GAS_PRICE);`

## Storage

- Cada ``slot`` es de ``32 bytes`` de largo. Y representa la version de bytes del objeto.

  - Por ejemplo el `uint256` es `0x000...0019` <----- este es el hex representation.
  - Para un `booleano "True"`, seria `0x000...001` <----- este es el hex representation.

- Para valores dinamicos como `Mappings` y `Arrays`, los elementos son almacenados usando una `funcion Hash (keccak256)`.

  - Para `arrays` un lugar sequencial de almacenamiento es tomado por el length del array.
  - Para `Mappings` un lugar sequencial de almacenamiento es tomado, pero queda en blanco.

- Las `variables constantes e immutables` no estan en el almacenanamiento. Pero son consideradas parte del ``core del bytecode`` del contrato.

- Cuando tenemos variables dentro de una funcion, esas variables unicamente existen para la direccion de la funcion.
  - No persisten en el contrato no son permanentes.
  - Son `Memory Variables`.

Este comando nos permite ver el storge de nuestro contrato.

```Shell
$ forge inspect FundMe storageLayout
```

Otra manera que podemos ver el storage es con ``Cast``:

```Shell
$ cast storage <direccion del contrato> <numero del slot que queramos leer>
```

    - Por ejemplo:

```Shell
$ cast storage 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 2
0x0000000000000000000000005fbdb2315678afecb367f032d93f642f64180aa3
```

## RCORDAR✌️

Porque una varible este escrita ``privada`` NO significa que sea privada, todo en la blockchain es informacion publica y quien sea puede leer facilmente la informacion off de cualquier blockchain.

## Intaractions.s.sol
https://github.com/Cyfrin/foundry-devops

* Usamos *(ffi = true)* en `foundry.toml` git sta para permitirle a foundry correr comandos directamente en mi maquina.

- Creamos un archivo en la carpeta `Script` llamado `Interactions`, y ahi dentro codeamos dos contratos, en nuestro caso para testear las dos funciones del contrato FundMe `fundMe()` & `withdraw`. 
- Importamos `DevOpsTools` de `Cyfrin`---> que es Un repositorio para obtener la implementación más reciente de un entorno dado en Foundry. De esta manera, puedes realizar scripts basados en implementaciones anteriores en Solidity.

//////////////////////////////////////////////
IMPORTANT - IMPORTANT  
//////////////////////////////////////////////
- Comando para instalarlo y tenerlo a disposicion cuando lo necesitemos.
  ```shell
  forge install Cyfrin/foundry-devops --no-commit
  ```
- La carpeta de `Test` la actualizamos y creamos 2 archivos 

1. **Unit Test**: Las pruebas unitarias se centran en probar componentes ``individuales`` y ``aislados`` de código, como ``funciones``, ``métodos`` o ``clases``, de manera independiente. Estas pruebas se realizan para verificar que cada ``unidad de código`` funcione correctamente según su diseño y especificación. Generalmente, se ejecutan en un entorno controlado y aislado, utilizando "``mocks``" o ``simulaciones`` de las dependencias externas.

2. **Integration Tests**: Las pruebas de integración se centran en probar la ``interacción`` y la ``colaboración`` entre diferentes componentes o módulos del sistema. Estas pruebas buscan identificar problemas que puedan surgir cuando varias partes del sistema interactúan entre sí, como comunicación entre servicios, bases de datos y componentes externos.

## Makefiles
Nos perminte crear shortcuts para comandos que comunmente vamos a usar.

## Comando para deployar los contratos el la testnet de Sepolia 
//////////////////////////////////////////////
IMPORTANT - IMPORTANT  
//////////////////////////////////////////////
**No colocar PRIVATE_KEY con dinero real** No quieras ser Hackeado :)
```shell
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```