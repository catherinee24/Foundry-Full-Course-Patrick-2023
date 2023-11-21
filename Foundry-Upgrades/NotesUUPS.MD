## Lesson 13: Foundry Upgrades ✨
Foundry course: FOUNDRY-UPGRADES
5:00:50

## (UUPS) Universal Upgradeable Proxy Standard (Setup) ✨
- In **UUPS proxies** the upgrade is handled by the implementation, and can eventually be removed.
- **UUPS proxies** are implemented using an **ERC1967Proxy**.
  -  **EIP-1967: Standard Proxy Storage Slot**
  A consistent location where proxies store the address of the logic contract they delegate to, as well as other proxy-specific information
- **UUPS proxies** es un poco más barato de deployar que **Transparent proxy**

### Empezando a crear los contratos 🧑‍🔬
- Creamos un contrato llamado **BoxV1.sol**
  - Ok, como estamos usando **UUPS proxy**, vaamos a necesitar agregar todo el proxy upgredeability dentro de el contrato **BoxV1.sol**
  - este contrato **BoxV1** es bastante simple y sirve como un contenedor de un número entero y una función para obtener ese número. También tiene una función adicional para proporcionar información sobre la versión del contrato.

- Creamos una función llamada **BoxV2.sol**
  - Copiamos y pegamos el contrato BoxV1 al BoxV2
