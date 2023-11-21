## Lesson 13: Foundry Upgrades ✨

Foundry course: FOUNDRY-UPGRADES
5:00:50

## (UUPS) Universal Upgradeable Proxy Standard (Setup) ✨

- In **UUPS proxies** the upgrade is handled by the implementation, and can eventually be removed.
- **UUPS proxies** are implemented using an **ERC1967Proxy**.
  - **EIP-1967: Standard Proxy Storage Slot**
    A consistent location where proxies store the address of the logic contract they delegate to, as well as other proxy-specific information
- **UUPS proxies** es un poco más barato de deployar que **Transparent proxy**

### Empezando a crear los contratos 🧑‍🔬

- Creamos un contrato llamado **BoxV1.sol**

  - Ok, como estamos usando **UUPS proxy**, vaamos a necesitar agregar todo el proxy upgredeability dentro de el contrato **BoxV1.sol**
  - este contrato **BoxV1** es bastante simple y sirve como un contenedor de un número entero y una función para obtener ese número. También tiene una función adicional para proporcionar información sobre la versión del contrato.

- Creamos una función llamada **BoxV2.sol**
  - Copiamos y pegamos el contrato **BoxV1** al **BoxV2** y lo cambiamos un poco.
  - Va a retornar el **numero 2** como versión en la función **version()**.
  - Agregamos una función nueva llamada **setNumber(unit256 \_number)**

## Vamos a hacer BoxV1 actualizable (Upgradeable) ✨

> 💡 Vamos a installar openzeppelin-contracts-upgradeable del repo de openzeppelin, porque necesitamos importar varios archivos que necesitaremos.

- [openzeppelin-contracts-upgradeable](https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable)

- Lo primero que necesitaremos es importar el **UUPSUpgradeable** contract from **OZ**

### Initializable.sol ✨

- Dado que los contratos proxy **no utilizan un constructor**, es común trasladar la lógica del constructor a una función externa de inicialización, generalmente llamada **initialize**. Luego se vuelve necesario proteger esta función de inicialización para que solo pueda ser llamada una vez. El modificador {**initializer**} proporcionado por este contrato tendrá este efecto.

> ✨REMEMBER✨: storage is stored in the proxy, Not implementation. Es por esto que los proxies no usasn contructores.
> proxy -> dploy implementation -> call some "initializer" function.

- **\_disableInitializers();** Llamamos a esta funcion en el **constructor()**:
  - Bloquea el contrato, impidiendo cualquier futura reinicialización. Esto no puede formar parte de una llamada de inicializador. Llamar a esto en el constructor de un contrato evitará que ese contrato se inicialice o reinicialice a cualquier versión. Se recomienda usar esto para bloquear contratos de implementación que están diseñados para ser llamados a través de proxies.

```solidity
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }
```
