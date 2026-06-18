# Test Data & Pruebas — ms-produccion

## A / B / C

| Rol | Clase | Ubicacion | Metodos clave |
|-----|-------|-----------|---------------|
| **A** | TestDataFactory (common) | common test-jar | seedMoneda(), seedSucursal(), seedArticulo() |
| **B** | ProduccionTestDataFactory | src/main/.../testdata/ | ensurePlanificacionData() |
| **C** | ProduccionTestFixtures | src/test/.../ | otTipo(), otTipoRequest() |

## Comandos

```bash
# Unit tests (rapido, sin BD)
mvn test -pl ms-produccion

# Solo integration tests
mvn test -pl ms-produccion -Dgroups=integration

# Con cobertura
mvn clean verify -pl ms-produccion
```
