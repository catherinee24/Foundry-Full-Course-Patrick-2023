## Advanced Section: Encoding, Opcodes and Calls. ✨
### EVM Overview
La **EVM** o **Ethereum Virtual Machine**, en una computadora que maneja **SMART CONTRACTS DEPLOYMENTS** y ejecucion.
                                        Contract.abi
- Contract.sol --------> solc compiler 
                                        Contract.bin

### Campos de una transacción:
- **Nonce**: Recuento de transacciones para una cuenta.
- **Gas Price**: Precio por unidad de gas (en wei).
- **To**: Dirección a la que se envía la transacción.
- **Value**: Cantidad de wei a enviar.
- **Data**: Lo que se le envia a la direccion **To**. 
- **v,r,s**: Componentes de la firma de una transacción.

### Campo de una transacción que crea un Smart Contract.
- **Nonce**: Recuento de transacciones para una cuenta.
- **Gas Price**: Precio por unidad de gas (en wei).
- **To**: Dirección a la que se envía la transacción.
- **Value**: Cantidad de wei a enviar.
- **Data**: Lo que se le envia a la direccion **To**. 
- **v,r,s**: Componentes de la firma de una transacción.

### abi.encode() and abi.encodePacked()
9:45:26 <----- **Youtube minutes of the lesson**.

#### abi.encodePacked()
- Con **abi.encodePacked()** : Podemos **combinar** o **concatenar** **Strings**. **abi.encodePacked()** retorna un **bytes object**. El ejemplo lo podemos encontrar en el archivo **Encoding:combineStrings()**.
- En la **version 0.8.12 +** de solidity se puede usar: **string.concat(stringA, stringB)**.