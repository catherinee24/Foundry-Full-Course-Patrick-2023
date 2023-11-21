## Lesson 13: Foundry Upgrades ✨
Foundry course: FOUNDRY-UPGRADES
4:47:16

## Proxy Terminology ✨
1. **El contrato de implementación** 💡
   - Tiene toda la Logica o el codigo de nuestro protocolo. Cuando hacemos un upgrade, lanzamos un contrato de implementación totalmente nuevo.
2. **El contrato Proxy** 💡
   -  Indica cuál es la implementación 'correcta' y dirige las llamadas de funciones de todos hacia ese contrato.   
3. **El usuario**
   - Hancen las llamadas a el Proxy.
4. **El administrador** 
   - Este es el usuario o (grupo de usuarios/ voters) quienes actualizan los nuevos contratos de implementación.  

## Las 3 implementaciones de contratos Proxy ✨
- **Transparent Proxy Parent:**
  - Los administradores no pueden llamar a las funciones del contrato de implementación.
  - Los administradores solo pueden llamar a las admin functions
    - **Admin functions**: Funciones que goviernan las actualizaciones.
  - Admin functions estan alocadas en el contrato de implementación.