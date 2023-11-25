# Lesson 15: Smart Contract Security & Auditing (For developers) ✨

## ¿Qué es una auditoria de Smart Contract? ✨

- Una auditoría de Smart Contract es un proceso de revisión minuciosa del código fuente de un contrato inteligente para identificar y corregir posibles problemas de seguridad, vulnerabilidades y errores.
- Esta práctica es esencial para garantizar que el contrato sea seguro, cumpla con los requisitos y funcione como se espera, especialmente en entornos de blockchain donde la inmutabilidad y la ejecución automática de los contratos pueden tener consecuencias significativas en caso de errores.

## Cúal es la meta de un auditor? ✨

- El goal del auditor es identificar cuantas vulnerabilidades sean posibles y educar al protocolo sobre las mejores prácticas de seguridad y codigo.
- Los auditores usan una combinación de revisión manual y herramientas de automatización para identificar las vulnerabilidades.

## Una típica auditoria luce como esto : ✨

### 1. Precio y cronología:

- Primero un protocolo necesita ponerse en contacto, se pueden poner de acuerdo antes o despues de terminar de codear el proyecto.
- Una vez que se ponen en contacto, el protocolo y los auditores descutirán los siguientes temas:
  - Complejidad del código.
  - Scope
  - Duración
  - Timeline
- Scope: El código que será auditado.
- Duración de una auditoría segun las líneas de código sin incluir natspec:

  - 100: 2.5 days
  - 500: 1 week
  - 1000: 1/2 weeks
  - 2500: 2/3 weeks
  - 5000: 3/5 weeks
  - 5000+: 5+ weeks

### 2. Commit hash, down payment, Start date:
  - El commit hash es el Id único del codebase con el que estás trabajando.
  - Algunos auditores cobrán un pago inicial para poder agendarte.
  - La auditoria comienza, y los auditores identificaran la cantidad de bugs que les sea posible.

### 3. Initial Report:
  - Despues de que termine el periodo de inicio de la auditoria, los auditores le darán al protocolo un reporte, con todos los hallazgos y severidades usualmente catagorizados como:
    - Highs
    - Mediums
    - Lows
    - Informationals / Non-Criticals
    - Gass efficiencies

### 4. Mitigations begins:
  - El equipo de desarrolladores del protocolo tendrán algo de tiempo para corregir las vulnerabilidades halladas en el reporte de auditoria. A veces dependiendo de el nivel de complejidad de la vulnerabilidad se tiene que empezar desde cero, en caso de que no sea así pueden usar las recomendaciones que los auditores proveen.

### 5. Final Report:
  - Despue de que el protocolo haga los cambios especificado, el auditor hará un reporte final exclusivamente sobre los cambios. 

- **Para hacer que la auditoria sea lo más exitosa posible se deben tener en consideración los siguientes conceptos:**
  - Antes de auditar se debería tener lo siguiente:
  - Documentación clara y detallada.
  - Suite de test robusta idealmente incluyendo Fuzz/Invariant test
  - El codigo debe estar documentado y leible
  - Seguir con la mejores practicas modernas
  - Canal de comunicaciones entre developer/protocol y auditores.
  - Hacer un video inicial de la revisión de código antes de que inice la auditoria.

- **EL 80% de los bugs hallados en por business logic implementation.**
  - Por esto es importante que los developers sepan lo que el codigo deberia de hacer.

### 6. Qué no es una auditoria?
- Una auditoria no significa que tu codigo estrá libre de bugs, una auditoria en un camino de seguridad entre el protocolo y el auditor para encontrar cuantos bugs sean posibles y enseñar al protocolo metodologías diferentes para estar más seguros en el futuro.
- La seguridad en un proceso continuo que está siempre mejorando, no importa cuanta experiencia alguien tiene, seimpre se perderán vulnerabilidades.