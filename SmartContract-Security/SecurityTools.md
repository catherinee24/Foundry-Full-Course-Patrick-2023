# Lesson 15: Smart Contract Security & Auditing (For developers) ✨

## Procesos que un auditor sigue & herramientas que usan ✨
### Proceso de Auditoria:
- **Revisión manual:**
  - Ir a través de la documentación y el codigo.
  - Entender lo que el protocolo debería hacer.
> ✨La repetición es la madre de las hábilidades, miestras más código leas, más documentación leas, y más auditorias hagas, mejor serás ✨   
- **Usar Tools/herramientas:**
  - **Static Analysis:** Slither, analyzer, mythril
  - **Fuzz Testing:** Foundry (se trata de proveer random data como input durante el test).
  - **Stateful fuzz testing:** fuzz teststing, pero el sistema recuerda el estado del ultimo fuzz test y continua con un nuevo fuz test.
  - **Formal Verification:** (Prueban matematicamente que algo en tu codigo no puede pasar) Es un termino generico para aplicar formal methods para verificar las correciones del hardware. Aplicando formal methods (FM) significa cualquier cosa basada en pruebas matemáticas, a menudo usado en software como una prueba de correcciones o prueba de bugs.
  
  - **Symbolic execution:** Una forma de Formal verfication seria, convertir tu software a expresión matemática.
> ✨ Take solidity function -> Math. Math can be solved.

## Formal Verification ✨
  
