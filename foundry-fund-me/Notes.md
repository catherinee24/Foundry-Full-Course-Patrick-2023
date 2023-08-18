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
```**shell**
$ forge test --match-test testPriceFeedVersionIsAccurate --fork-url $SEPOLIA_RPC_URL
```

Para ver que tanto está testeado el proyecto.
```shell
$ forge coverage --fork-url $**SEPOLIA_RPC_URL**
```

## Archivo Helper Config 
Hicimos un archicvo en Script llamado `HelperConfig` para utilizar de manera automatica las networks que estemos usando, ya sea Testnet como SEPOLIA o Mainnet como ETHEREUM. 

## Mocks 
Un contrato Mock es basicamente un contrato falso que vamos a estar usando en el script de helper config en la funcion de Anvil.
Los Mocks los creamos en la carpeta de tests.

## Magic Numbers
Evitar tener magic numbers en funciones, es mejor pratica hacer variables constantes.

## Foundry Cheatcodes
Podemos encontrar todos los cheatcodes que fondry propociona en su pag.
https://book.getfoundry.sh/cheatcodes/expect-revert

En el curso vimos unos cuantos como:
-   `vm.expectRevert();`
-   `vm.prank();`
-   `vm.makeAddr();`
-   `vm.deal();`
