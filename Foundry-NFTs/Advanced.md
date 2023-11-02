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

### abi.encode() - abi.encodePacked() - abi.decode()
9:45:26 <----- **Youtube minutes of the lesson**.

#### abi.encodePacked()
- Con **abi.encodePacked()** : Podemos **combinar** o **concatenar** **Strings**. **abi.encodePacked()** retorna un **bytes object**. El ejemplo lo podemos encontrar en el archivo **Encoding:combineStrings()**.
- En la **version 0.8.12 +** de solidity se puede usar: **string.concat(stringA, stringB)**.

## Ejemplos: 
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
> ✨ Note: Copia y pega el codigo en Remix, compila y deploya, y ve los outputs de cada funcion !!
## Introducion a Encodear llamadas de funciones directamente.
### Transactions - Function call
- **Nonce**: Recuento de transacciones para una cuenta.
- **Gas Price**: Precio por unidad de gas (en wei).
- **Gas Limit**: Maximo gas que la tx puede usar.
- **To**: Empty.
- **Value**: Cantidad de wei a enviar.
- **Data**: Lo que se envia al **To** address.
- **v,r,s**: Componentes de la firma de una transacción.

## how do we send transactions with just the data field populated? How do we populate de data field? 
## ¿Cómo enviamos transacciones con solo el campo de datos completado? ¿Cómo poblamos el campo de datos?
- **Solidity** tiene algunas **"Low-Level" Keywords** llamadas: **Staticcall** & **call**.

### Call 
- Es como llamamos a las funciones para **cambiar el estado de la blockchain**. 
>✨Nota: Learn Solidity, Blockchain Development, & Smart Contracts | Powered By AI - Full Course (7 - 11): Minuto 10:10:57 Explicacion del call en codigo.

## Staticcall
Esto es como a **"Low-Level"** hacemos nuestra llamada de funcion "**view**" o "**pure**". **No cambia el estado de la blockchain, solo nos da el valor retornado**.

### Ejemplos:
```solidity
    function withdraw(address _recentWinner) public {
        (bool success, ) = _recentWinner.call{value: address(this).balance}("");
        require(success, "Tranfer Failed"); 
    }
```
