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

## Delegatecall ✨