# Test Data y Pruebas — ms-rrhh

> **Última actualización: 02/06/2026** — creado post-auditoría. Los conteos de tests pueden variar respecto al diagnóstico del 28/05/2026 (267 tests con 18 failures en ese momento).

## Modelo A / B / C

| Rol | Clase | Ubicación | Métodos clave |
|-----|-------|-----------|---------------|
| **A** | `TestDataFactory` / `TestDataSeeder` | `common` test-jar | `seedMoneda()`, `seedSucursal()`, `seedEntidadContribuyente()`, `seedTiposDocumento()`, `seedCentrosCosto()`, `seedPlanContable()`, `seedDocTipo()`, `seedDocTipoNumSerie()` |
| **B** | `RrhhTestDataFactory` | `src/main/.../testdata/` | `ensureAreaTestData()`, `ensureCargoTestData()`, `ensureAdminAfpTestData()`, `ensureTipoNovedadRrhhTestData()`, `ensureConceptoPlanillaTestData()`, `ensurePermisoLicenciaTestData()`, `ensureCapacitacionTestData()`, `ensureNovedadRrhhTestData()`, `ensureGanDescFijoTestData()` |
| **C** | `RrhhTestFixtures` | `src/test/.../` | `trabajador()`, `area()`, `cargo()`, `tipoNovedadRrhh()`, `ganDescFijo()`, `permisoLicencia()`, `capacitacion()`, `novedadRrhh()`, `prestamo()`, `cntaCrrte()`, etc. |

## Tests unitarios (372 tests, 0 failures ✅)

| Tipo | Cantidad |
|------|----------|
| Service `*ImplTest` | 10 |
| Service `*ServiceTest` | 2 |
| Validator `*ValidatorTest` | 6 |
| Mapper `*MapperTest` | 8 |
| Specification `*SpecificationTest` | 4 |
| Constants `*ConstantsTest` | 3 |
| Controller (MockMvc standalone) | 2 |
| Entity/DTO | 2 |

## Tests de integración (94 tests, 62 failures 🔴)

### Pendientes de corregir:

| IT | Failures | Causa raíz |
|----|----------|------------|
| `TurnoControllerIntegrationTest` | 4 | Datos preexistentes en BD, orden de tests, `updatedBy` null |
| `GanDescFijoControllerIntegrationTest` | 6 | Helper `crearTrabajador()` retorna 400 |
| `PermisoLicenciaControllerIntegrationTest` | 11 | Helper `crearTrabajador()` en setUp retorna 400 |
| `Area/Cargo/ConceptoPlanillaControllerIntegrationTest` | ~20 | Creación POST retorna 400 + DELETE usa 405 |
| `AdminAfpControllerIntegrationTest` | 6 | Creación retorna 400, DELETE 405 |
| `TipoNovedadRrhhControllerIntegrationTest` | 5 | Creación retorna 400 |

### Comandos

```bash
mvn test -pl "02. Backend/ms-rrhh" -Dsurefire.excludedGroups=integration  # unitarios
mvn test -pl "02. Backend/ms-rrhh" -Dgroups=integration                    # integración
```
