## Advanced Section: Encoding, Opcodes and Calls. ✨
9:55:06
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
- **Gas Limit**: Maximo gas que la tx puede usar.
- **To**: Empty.
- **Value**: Cantidad de wei a enviar.
- **Data**: Contract init code & Contract bytecode. 
- **v,r,s**: Componentes de la firma de una transacción.

### abi.encode() and abi.encodePacked()
9:45:26 <----- **Youtube minutes of the lesson**.

#### abi.encodePacked()
- Con **abi.encodePacked()** : Podemos **combinar** o **concatenar** **Strings**. **abi.encodePacked()** retorna un **bytes object**. El ejemplo lo podemos encontrar en el archivo **Encoding:combineStrings()**.
- En la **version 0.8.12 +** de solidity se puede usar: **string.concat(stringA, stringB)**.

## Ejemplos aplicados en el eviroment de Remix 
```solidity
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Encoding {
    function concatStrings() public pure returns(string memory){
        return string(abi.encodePacked("Hey Mom!! ", "You look so pretty today!!"));
    }

    function encodeNumber() public pure returns(bytes memory){
        bytes memory number = abi.encode(1);
        return number;
    }

    function encodeString() public pure returns(bytes memory){
        bytes memory str = abi.encode("Hey buddy!!");
        return str;
    }

    function encodeStringPacked() public pure returns(bytes memory){
        bytes memory str= abi.encodePacked("Hey buddy!!");
        return str;
    }

    function encodeStringBystes() public pure returns(bytes memory){
        bytes memory str= bytes("Hey buddy!!");
        return str;
    }

    function decodeString() public pure returns(string memory){
        string memory someString= abi.decode(encodeString(), (string));
        return someString;
    }

    function multiEncode() public pure returns(bytes memory){
        bytes memory str = abi.encode("hey ur amazing!", "And beautiful!");
        return str;
    }

    function multiDecode() public pure returns(string memory, string memory){
        (string memory firstString, string memory secondString) = abi.decode(multiEncode(), (string, string));
        return (firstString,secondString);
    }

    function multiEncodePacked() public pure returns(bytes memory){
        bytes memory firtsString = abi.encodePacked("hey ur amazing!", "And bautiful");
        return firtsString;
    }

    function multiStringCastPacked() public pure returns(string memory){
        string memory firstString = string(multiEncodePacked());
        return firstString;
    }
}

```
