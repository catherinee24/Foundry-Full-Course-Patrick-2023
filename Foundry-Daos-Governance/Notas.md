# Lesson 14: Foundry DAO / Governance ✨
> 💡 Plutocracy is bad! Don't default to ERC20 token voting!!
Foundry course: FOUNDRY-DAOs-GOVERNANCE
7:00:50 -

## Artículos recomendados sobre DAOs ✨
- [Governance, Part 2: Plutocracy Is Still Bad](https://vitalik.ca/general/2018/03/28/plutocracy.html)
- [DAOs are not corporations: where decentralization in autonomous organizations matters](https://vitalik.ca/general/2022/09/20/daos.html)

## ¿Qué es una Dao? ✨
- **D** ecentralized
- **A** utonomous
- **O** rganization

Una **DAO** describe a cualquier grupo que está gorvernado por una serie de reglas transparentes. Una Dao se encuentra en la **Blockchain** o **Smart Contracts**. Lo podemos resumir como: 
- **Company / Organization operado exclusivamente a través de código**.

## Foundry DAO / Governance (SetUp) ✨
1. Vamos a tener una contrato controlado por una **DAO**.
   - Vamos a hacer esto Ownable.
   - Hcemos un contrato llamado Box. el contrato almacena un simple número (s_number) que puede ser cambiado por el propietario del contrato y consultado por otros usuarios.

2. Cada votacion que la DAO quiere mandar tiene que haber sido votado.
3. Usaremos ERC20 Tokens para el modelo de votación (Modelo no recomendado a seguir, haz más investigaciones sobre que modelo usar, a medida que te vuelves mejor).
   - Vamos a crear nuestro Token de governanza.
   - Usamos **contracts wizard by openzeppelin** para crear rapidamente nuestro **Token**. Clicamos en la opcion de votin y oz wizard hace todo por nosotros.

4. Ahora necesitamos la **DAO**, necesitamos un contrato que maneje **Box** y **GovernaceToken**.
   - Wizard de Openzeppelin tiene un contrato, Llamado **MyGovernor** 

5. Por ultimo necesitamos hacer el **contrato TimeLock()**
   - Importamos **TimeLockController** contract by openzeppelin y lo heredamos a nuestro contrato **TimeLock.sol**

## Foundry DAO / Governance (TEST) ✨
- Escribios como siempre nuestro contrato que se llamará **MyGovernorTest.t.sol** 
- Primero deployamos el **token de governanza** y le minteamos algo de tokens a USER. También le delegamos esos Tokens.
- Luego deployamos el **TimeLock**, porque para poder deployar el contrato **MyGovernor** vamos a necesitar ambos, el **token de governanza y el Time lock**.
- Deployamos ahora nuestro contrato **MyGovernor** y le pasamos el **token de governanza y el TimeLock**.
- Deployamos el **Box**.
- Ahora le pasamos el **ownership** al del **Box** al **TimeLock**.
> ✨ El timeLock owns the dao.