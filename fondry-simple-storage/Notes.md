## Notes about the Proyect & Foundry ✌️
### Summary
- Para crear un nuevo proyecto en Foundry: 
  - forge --init 

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

### Comands for deployment & interaction with the contract:
   
  1. .env: (Para guardar lo que tengamos en nuestro archivo .env en nuestro proyecto)
```shell
$ source .env
```
   2.  Deploy:
```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```
  3. cast:
```shell
$ cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "store(uint256)" 123 --rpc-url $RPC_URL --private-key $PRIVATE_KEY**
```
  4. cast call: llamada a funciones view
```shell
$ cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "retrieve()"
``` 
  
  5. cast --to-base: castea de hexa a decimal
```shell
$ cast --to-base 0x000000000000000000000000000000000000000000000000000000000000007b dec
       123
```
  6. Formatear: formatea el codigo para que quede limpio y leible.
```shell
$ forge fmt
```

### Para hacer un script:
 *  1. Importamos el archivo Script de la libreria `forge-std`. 
 *  2. importamos el contrato que queramos deployar.
 *  3. Empezamos el Script con una funcion publica llamada `run()` que devolvera el contrato a deployar
 *  4. `vm.startBroadcast()` nos dice: ¡Hey todo lo que esta despues de esta linea dentro de esta funcion  deberias de enviarlo al RPC!.
  Todo lo que esta aqui dentro: 

            ```shell
            vm.startBroadcast();
            SimpleStorage simpleStorage = new SimpleStorage();
            vm.stopBroadcast(); // Es lo que vamos a deployar
            ```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
    
