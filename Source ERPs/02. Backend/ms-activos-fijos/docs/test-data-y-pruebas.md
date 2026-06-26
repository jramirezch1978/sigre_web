# Datos de prueba y estrategia de tests — `ms-activos-fijos`

Alineado al lineamiento QA (unitarios sin BD; IT con BD real, factory A/B/C, rollback; MockMvc en flujos HTTP).

## Tres mecanismos (A / B / C)

| Rol | Mecanismo | Ubicación | Persiste | Uso |
|-----|-----------|-----------|----------|-----|
| **A** | `pe.restaurant.common.testutil.TestDataFactory` | `common` test-jar | Sí (JDBC mínimo cross-módulo) | IT: `ActivosItSeed.standard(dataSource, factory)` |
| **B** | `ActivosTestDataFactory` | `src/main/java/.../testdata/` | Sí (grafo activos + contabilidad factory) | IT: `ensureActivosTransactionalData()`, `resolve*Id()` |
| **C** | `TestDataFactory` + `ActivosTestFixtures` | `src/test/java/...` | No | Unitarios Mockito y cuerpos HTTP en IT |

No mezclar C con B en unitarios: los `*ServiceImplTest` / `*ControllerTest` no deben abrir BD.

## Anotaciones IT

| Anotación | Efecto |
|-----------|--------|
| `@ActivosIntegrationTest` | `@Tag("it")`, `-Dactivos.it=true`, `@Transactional` (rollback) |
| `@ActivosIntegrationMockMvcTest` | Lo anterior + `@AutoConfigureMockMvc` |

MockMvc IT requieren cabecera `X-Empresa-Id: 2` (`ActivosMockMvcSupport`) y `ActivosTestSecurityConfig` en `support/` (perfil `test`).

## Estructura de carpetas en `src/test`

| Carpeta | Contenido |
|---------|-----------|
| `support/` | Anotaciones IT, MockMvc, seguridad test, `ControllerMockMvcFactory`, `JdbcContabilidadAsientosClient` |
| `integration/` | IT HTTP (`*ControllerIT`), IT contabilidad, tests unitarios del paquete `main/integracion` |
| `controller/` | Tests unitarios de controladores (Mockito) |
| `service/` | Tests unitarios de servicios |
| `testdata/` | IT del factory (rol B) |

Persistir dataset en BD para QA manual (sin rollback):

```bat
mvn test -pl ms-activos-fijos -Dactivos.it=true -Dactivos.it.persist=true -Dtest=ActivosTestDataPersistIT
```

## Tests por capa

| Tipo | Ejemplos | Comando |
|------|----------|---------|
| Unitarios (Mockito) | `*ServiceImplTest`, `*ControllerTest`, `*MapperTest` | `mvn test -pl ms-activos-fijos` |
| Contrato Feign | `ContabilidadAsientosClientTest`, `ContabilidadAsientosEndpointConsumoTest` | incluido en `mvn test` |
| IT factory / smoke | `ActivosTestDataFactorySmokeIT`, `ActivosTestDataExtendedIT` | ver bloque IT abajo |
| IT contabilidad | `ContabilidadIntegracionIT` (`@MockBean` Feign → `JdbcContabilidadAsientosClient`) | idem |
| IT HTTP (MockMvc) | `AfMaestroControllerIT`, `AfClaseControllerIT`, `AfCalculoCntblControllerIT`, `AfTrasladoControllerIT` | idem |

### Ejecutar todos los IT del módulo

```bat
cd c:\RESTAURANTPE\PROYECTOS\restpe-contabilidad-back-end\02. Backend
mvn test -pl ms-activos-fijos -Dactivos.it=true
```

### Etapa formal para CI / pre-release

El módulo expone un perfil Maven dedicado para correr las IT reales en una etapa controlada:

```bat
mvn verify -pl ms-activos-fijos -Pit-controlado
```

Ese perfil:

- activa `activos.it=true`
- ejecuta `*IT.java` con `maven-failsafe-plugin`
- deja fuera las IT del `mvn test` rápido estándar
- permite a QA/pipeline tener una etapa end-to-end explícita y repetible

Comando validado el `2026-05-25` para una tanda controlada ampliada:

```bat
mvn verify -pl ms-activos-fijos -Pit-controlado -Djacoco.skip=true -Dit.test=AfClaseControllerIT,AfCalculoCntblControllerIT,ContabilidadIntegracionIT,ActivosTestDataFactorySmokeIT
```

Resultado verificado:

- `14` tests ejecutados
- `0` fallos
- `0` errores
- `1` skipped por precondición explícita del tenant en un escenario de traslado contable

Subset:

```bat
mvn test -pl ms-activos-fijos -Dactivos.it=true -Dtest="AfMaestroControllerIT,AfClaseControllerIT,AfCalculoCntblControllerIT,AfTrasladoControllerIT,ContabilidadIntegracionIT,ActivosTestDataFactorySmokeIT,ActivosTestDataExtendedIT"
```

Por defecto `mvn test` **no** ejecuta clases IT (`@EnabledIfSystemProperty(activos.it=true)`).

Perfil: `src/test/resources/application-test.yml` (tenant PostgreSQL, Flyway off).

## Integración contable

| Capa | Clase |
|------|-------|
| Unitario mock client | `ContabilidadIntegracionServiceImplTest` |
| IT servicio + BD | `ContabilidadIntegracionIT` |
| Feign externo en IT | `@MockBean ContabilidadAsientosClient` → JDBC local (no es mock del dominio activos) |

`ActivosTestDataFactory` crea plan contable, matriz con cuentas y libro para que `contabilizarDepreciacion` no falle.

## Resolvers públicos (rol B, para IT)

`resolveMaestroId()`, `resolveMaestroIdByCodigo`, `resolveClaseId()`, `resolveSubClaseId()`, `resolveUbicacionId()`, `resolveCalculoDepreciacionContableId()`, `resolveTrasladoFactoryId()`, `resolveTrasladoEjecutadoContableId()`, etc.

## Dataset extendido y bulk

`ensureActivosTransactionalData()` incluye activos `FACTORY-AF-M`, `M2`, `M3`, cálculos multi-período, valuaciones, documentos, historial, etc.

`ActivosTestDataFactoryBulk`: **100** filas idempotentes por tabla (`BULK_ROWS_PER_TABLE`). Prefijos `FACTORY-AF-BULK-001`, `FACTORY-AF-CL-B001`, …

## Seed admin (demo)

`POST /api/activos-fijos/admin/test-data/seed` con `app.testdata.enabled` — no sustituye A/B/C en tests automatizados.

## Constantes estables

**C (unitarios):** `TestDataFactory.CODIGO_MAESTRO`, `CODIGO_CLASE`

**B (IT):** `ActivosTestDataFactory.CODIGO_MAESTRO`, `CODIGO_CLASE`, `CODIGO_SUB_CLASE`, `CODIGO_UBICACION_A`, …

## JaCoCo

- Bundle ~**87%** instrucciones (sin gate en `pom` del módulo; incluye paquete `testdata` en main).
- HTML: `ms-activos-fijos/target/site/jacoco/index.html`.
- Consolidado: `02. Backend/docs/reporte-jacoco-activos-almacen-ventas.md`.
- Orquestación: `05. Documentacion/orquestacion/ORQUESTACION_MS-ACTIVOS-FIJOS.md` (§ Pruebas automatizadas).

`testdata` en `main` queda fuera del camino de unitarios; la factory JDBC solo corre con `-Dactivos.it=true`.
