## RaffleTest:testfulfillRandomWordsCanOnlyBeCalledAfterPerformUpkeep() <------- Aplicamos Fuzz Test 
Las pruebas de **fuzz (fuzz testing)** son una técnica de prueba de software que se utiliza para descubrir problemas de seguridad y estabilidad en programas al **inyectar datos de prueba aleatorios**, corruptos o inesperados. Lo más importante a destacar es que las pruebas de fuzz:

1. Se centran en probar cómo un programa responde a datos inesperados o maliciosos.

2. Se automatizan para generar grandes cantidades de datos de prueba aleatorios y aplicarlos al programa de manera rápida.

3. Son efectivas para descubrir vulnerabilidades de seguridad, como desbordamientos de búfer e inyecciones de código.

4. Ofrecen una cobertura amplia al probar muchos casos con datos aleatorios.

5. Requieren que los resultados sean controlados y registrados para reproducibilidad.

6. Pueden ser iterativas para mejorar la efectividad con el tiempo.

**En resumen, el fuzz testing es una técnica de prueba importante para descubrir problemas de software, especialmente en términos de seguridad y estabilidad, al someter programas a datos inesperados y aleatorios.**

[Foundry Book Fuzz Test ](https://book.getfoundry.sh/reference/config/testing?highlight=Fuzz#fuzz).

## Entendiendo el test
En la funcion de test **testfulfillRandomWordsCanOnlyBeCalledAfterPerformUpkeep()** agregamos un parametro **_randomRequestId** con esto **Foundry** va a crear un  randomNumber para -------> **_randomRequestId** y va a llamar este test muchas veces con muchos random numbers.

### Output de la terminal despues de correr el test testfulfillRandomWordsCanOnlyBeCalledAfterPerformUpkeep()
```shell
[PASS] testfulfillRandomWordsCanOnlyBeCalledAfterPerformUpkeep(uint256) (runs: 256, μ: 78327, ~: 78327)
```
*  (runs: 256) <-------- **Nos indica que Foundry generó 256 diferentes random numbers.**

