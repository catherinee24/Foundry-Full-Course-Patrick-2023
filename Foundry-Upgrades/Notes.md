## Lesson 13: Foundry Upgrades ✨

Foundry course: FOUNDRY-UPGRADES
5:00:50

## Proxy Terminology ✨

El objetivo principal de un proxy es permitir actualizaciones en un contrato inteligente sin afectar su dirección o la lógica principal que realiza.

1. **El contrato de implementación** 💡
   - Tiene toda la Logica o el codigo de nuestro protocolo. Cuando hacemos un upgrade, lanzamos un contrato de implementación totalmente nuevo.
2. **El contrato Proxy** 💡
   - Actúa como un intermediario entre los usuarios y la implementación lógica. Los usuarios interactúan con el proxy como si fuera el contrato principal, pero en realidad, el proxy redirige esas interacciones a la implementación lógica.
3. **El usuario**
   - Hancen las llamadas a el Proxy.
4. **El administrador**
   - Este es el usuario o (grupo de usuarios/ voters) quienes actualizan los nuevos contratos de implementación.
5. **Actualización**
   - Cuando deseas actualizar el contrato, despliegas una nueva versión de la implementación lógica. El proxy se actualiza para apuntar a la nueva implementación lógica sin cambiar su propia dirección. De esta manera, los usuarios siguen interactuando con el mismo proxy, pero la lógica subyacente puede cambiar sin afectar la dirección principal del contrato.

## Las 3 implementaciones de contratos Proxy ✨

- **Transparent Proxy Patten:**
  - Los administradores no pueden llamar a las funciones del contrato de implementación.
  - Los administradores solo pueden llamar a las admin functions
    - **Admin functions**: Funciones que goviernan las actualizaciones.
  - Admin functions estan alocadas en el contrato de implementación.

- **Universal Upgradeable Proxies:**
  - Los administradores solo actualizan funciones que estan en el contrato de implementación en vez del proxy.


## Como crear Proxies? ✨
- Ahora vamos a aprender a como construir estos **Smart Contracts actualizables (Proxies)**.
- Para aprender a consruir proxies debemos saber que es **Delegatecall**?

### Delegatecall ✨
- **delegatecall** es una instrucción en Solidity y la Ethereum Virtual Machine (EVM) que permite a un contrato ejecutar la lógica de otro contrato en su propio contexto. 
- Esto se utiliza para implementar patrones de proxy que facilitan la actualización de la lógica de un contrato sin cambiar su dirección. 
- También se usa para crear bibliotecas compartidas, permitiendo que varios contratos utilicen la misma lógica sin duplicar código. 
- Es poderoso pero debe manejarse con precaución, especialmente en lo que respecta al almacenamiento compartido.
[Delegatecall](https://solidity-by-example.org/delegatecall/)
  - **delegatecall is a low level function similar to call**.
  - When contract A executes delegatecall to contract B, B's code is executed
  - with contract A's storage, msg.sender and msg.value.

- **Example 💡**
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// NOTE: Deploy this contract first
contract B {
    // NOTE: storage layout must be the same as contract A
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _contract, uint _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}
```

## Pequeño ejemplo de un proxy ✨
- **EIP-1967: Standard Proxy Storage Slot**
    A consistent location where proxies store the address of the logic contract they delegate to, as well as other proxy-specific information.