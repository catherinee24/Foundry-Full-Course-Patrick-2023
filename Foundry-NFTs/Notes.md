# Lesson 11: Foundry NFTs https://github.com/catherinee24/Foundry-Course-Patrick 🤩
8:46:46
Foudry course: FOUNDRY-NFTs

## Address de nuestro Basic Nft 🫡
0xE24A237Bc855010dB2161Ef63fBb26CB073Ff956

## ¿Qué es un NFT? ERC-721 Estandard 🤔

Las siglas de **NFT** significan **Non -Fungible Token**, un token no fungible. No fungible significa que algo es único y no se puede reemplazar.Cada **NFT** contiene una **firma digital** que hace que cada ejemplar sea único. Las **NFT** son activos digitales y pueden ser **fotos, videos, archivos de audio u otro formato digital.** Los ejemplos de **NFT** incluyen **ilustraciones, cómics, coleccionables deportivos, cartas coleccionables, juegos y más.**

## Diferencias entre ERC-721 & ERC-20

La principal diferencia entre estos dos estandares de tokens es que el ERC-20 es un simple mapping que tiene un address y que cantidad posee dicha address. El ERC-721 tine un token ID Unico, el token Id tiene un owner unico

## Ethereum documentation

https://eips.ethereum.org/EIPS/eip-721

## ¿Qué es IPFS? 🤔

El proyecto **InterPlanetary File System (IPFS)** o **Sistema de Archivos Interplanetario (IPFS)** es un curioso proyecto con un objetivo bastante claro: **crear una red de computadoras de alcance global que permita el almacenamiento de información de forma completamente descentralizada, con una alta escalabilidad, y por supuesto, con una gran resistencia a la censura de cualquier tipo.**

**IPFS** o **InterPlanetary File System**, es un sistema de archivo descentralizado que busca garantizar la seguridad, privacidad y resistencia a la censura de tus datos.

## Hosting en IPFS

- **Descargamos IPFS** ----> Para eso podemos ir a su pagina web y seguir los pasos de descargas.
- En la seccion del menú le damos a la seccion de **"Archivos"** y en la parte superior izquierda clicamos el botón **"Import"**, **importamos un archivo que no nos importe que sea publico** 🫡.
- Cuando aparezca el **archivo** subido en **IPFS**, clicamos los **3 puntitos(...)** que salen en la parte inquierda del **archivo** y le damos **Copiar CID**.
- Luego no vamos al **browser** (Google) o (Brave) o el que mas te guste, y escribimos **ipfs://QmNgQwuEuztsWKwYoCpbxNaQhAee31kARPmB6z85Evd3GK**
- QmNgQwuEuztsWKwYoCpbxNaQhAee31kARPmB6z85Evd3GK <-------- CID unico de tu archivo.

## Usamos Chisel en la consola para probar como podemos convertir un string a hash para usar keccak256(abi.encodePacked) en la funcion OurBasicNFTTokenTest:testNameIsCorrect().

Escribimos **chisel** en nuestra terminal y luego Este es nuestro Output. 🤌

```bash
$ chisel
Welcome to Chisel! Type `!help` to show available commands.
➜ string memory cat = "cat";
➜ string memory dog = "dog";
➜ cat
Type: string
├ UTF-8: cat
├ Hex (Memory):
├─ Length ([0x00:0x20]): 0x0000000000000000000000000000000000000000000000000000000000000003
├─ Contents ([0x20:..]): 0x6361740000000000000000000000000000000000000000000000000000000000
├ Hex (Tuple Encoded):
├─ Pointer ([0x00:0x20]): 0x0000000000000000000000000000000000000000000000000000000000000020
├─ Length ([0x20:0x40]): 0x0000000000000000000000000000000000000000000000000000000000000003
└─ Contents ([0x40:..]): 0x6361740000000000000000000000000000000000000000000000000000000000
➜ bytes memory encodedCat = abi.encodePacked(cat);
➜ encodedCat
Type: dynamic bytes
├ Hex (Memory):
├─ Length ([0x00:0x20]): 0x0000000000000000000000000000000000000000000000000000000000000003
├─ Contents ([0x20:..]): 0x6361740000000000000000000000000000000000000000000000000000000000
├ Hex (Tuple Encoded):
├─ Pointer ([0x00:0x20]): 0x0000000000000000000000000000000000000000000000000000000000000020
├─ Length ([0x20:0x40]): 0x0000000000000000000000000000000000000000000000000000000000000003
└─ Contents ([0x40:..]): 0x6361740000000000000000000000000000000000000000000000000000000000
➜ bytes32 catHas = keccak256(encodedCat);
➜ cathas
Compiler errors:
Error (7576): Undeclared identifier. Did you mean "catHas"?
  --> ReplContract.sol:18:1:
   |
18 | cathas;
   | ^^^^^^

➜ catHas
Type: bytes32
└ Data: 0x52763589e772702fa7977a28b3cfb6ca534f0208a2b2d55f7558af664eac478a
➜
```

```bash
Sorry 🙄 quise escribir **catHash** :)
```

- En la **consola** se muestra como podemos **convertir un string a hash** usado **abi.encodePacked() y keccak256**.

## Archivo Interactions
Una vez mas hicimos uso de Fonudry DevOps de Cyfrin!!
**Para instalar ⤵️**
```bash
$ forge install Cyfrin/foundry-devops --no-commit
```
### Comando para Deployar el contrato en Testnet 
```bash
$ forge script script/DeployRaffle.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```
## Base64 de Openzeppelin para encondear.
https://docs.openzeppelin.com/contracts/4.x/utilities

## Base64
**Base64** util allows you to transform **bytes32** data into its **Base64** string representation.

This is especially useful for building URL-safe tokenURIs for both ERC721 or ERC1155. This library provides a clever way to serve URL-safe Data URI compliant strings to serve on-chain data structures.
```bash
import {Base64} from "@openzeppelin/contracts/utils/base64.sol";
```