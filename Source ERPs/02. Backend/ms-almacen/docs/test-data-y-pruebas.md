# Datos de prueba y estrategia de tests — `ms-almacen`

Alineado al lineamiento QA (unitarios sin BD; IT con BD real, factory A/B/C, rollback; MockMvc en flujos HTTP).

## Tres mecanismos (A / B / C)

| Rol | Mecanismo | Ubicación | Persiste | Uso |
|-----|-----------|-----------|----------|-----|
| **A** | `pe.restaurant.common.testutil.TestDataFactory` | `common` test-jar | Sí (JDBC mínimo cross-módulo) | IT: `AlmacenItSeed.standard(dataSource, factory)` |
| **B** | `AlmacenTestDataFactory` | `src/main/java/.../testdata/` | Sí (21 tablas `almacen` + core/auth) | IT: `ensureAlmacenTransactionalData()`, `resolve*Id()` |
| **C** | `TestDataFactory` + `AlmacenTestFixtures` | `src/test/java/...` | No | Unitarios Mockito, `AlmacenFlowTest`, cuerpos HTTP en IT |

No mezclar C con B en unitarios.

## Anotaciones IT

| Anotación | Efecto |
|-----------|--------|
| `@AlmacenIntegrationTest` | `@Tag("it")`, `-Dalmacen.it=true`, `@Transactional` (rollback) |
| `@AlmacenIntegrationMockMvcTest` | Lo anterior + `@AutoConfigureMockMvc` |

MockMvc IT requieren cabecera `X-Empresa-Id: 2` (`AlmacenMockMvcSupport`) y `AlmacenTestSecurityConfig` (perfil `test`).

Persistir dataset en BD para QA manual (sin rollback):

```bat
mvn test -pl ms-almacen -Dalmacen.it=true -Dalmacen.it.persist=true -Dtest=AlmacenTestDataPersistIT
```

## Tests por capa

| Tipo | Ejemplos | Comando |
|------|----------|---------|
| Unitarios (Mockito) | `*ServiceImplTest`, `*ControllerTest`, `AlmacenFlowTest` | `mvn test -pl ms-almacen` |
| IT factory / smoke | `AlmacenTestDataFactorySmokeIT`, `AlmacenTestDataExtendedIT` | ver bloque IT |
| IT servicio | `ValeMovServiceIT` | idem |
| IT HTTP (MockMvc) | `ValeMovControllerIT`, `AlmacenControllerIT`, `OrdenTrasladoControllerIT`, `SolicitudesSalidaControllerIT` | idem |

### Ejecutar todos los IT del módulo

```bat
cd c:\RESTAURANTPE\PROYECTOS\restpe-contabilidad-back-end\02. Backend
mvn test -pl ms-almacen -Dalmacen.it=true
```

Subset:

```bat
mvn test -pl ms-almacen -Dalmacen.it=true -Dtest="ValeMovControllerIT,AlmacenControllerIT,OrdenTrasladoControllerIT,SolicitudesSalidaControllerIT,ValeMovServiceIT,AlmacenTestDataFactorySmokeIT,AlmacenTestDataExtendedIT"
```

Por defecto `mvn test` **no** ejecuta clases IT (`@EnabledIfSystemProperty(almacen.it=true)`).

Perfil: `src/test/resources/application-test.yml` (tenant PostgreSQL, Flyway off).

## Resolvers públicos (rol B)

`resolveValeMovId()`, `resolveAlmacenId()`, `resolveAlmacenIdByCodigo()`, `resolveAlmacenTipoId()`, `resolveSucursalId()`, `resolveOrdenTrasladoId()`, `resolveSolSalidaId()`, etc.

## Dataset masivo (~120 filas por tabla)

`AlmacenTestDataFactoryBulk` inserta de forma idempotente **120 filas** por tabla `almacen` con prefijos `FACTORY-AL-B*`, vales `BL*`, OT `OT*`, SS `SS*`, artículos `FAB-ART-*`, etc. Los códigos mínimos `LM-TEST-*` / `FACTORY-AL-01` no se alteran. Constante: `AlmacenTestDataFactory.BULK_ROWS_PER_TABLE`.

## Seed admin (demo)

`POST /api/almacen/admin/test-data/seed` con `app.testdata.enabled` — no sustituye A/B/C en tests automatizados.

## Constantes estables

**C (unitarios):** `TestDataFactory.NRO_VALE_FACTORY`, `CODIGO_ALMACEN`

**B (IT):** `NRO_VALE` = `LM-TEST-0001`, `CODIGO_ALMACEN_1` = `FACTORY-AL-01`, `NRO_OT`, `NRO_SS`, `ART-001`, etc.

## JaCoCo

- Gate Maven **≥ 80%** instrucciones (bundle; excludes en `pom.xml`: `entity`, `repository`, `dto`, `testdata`, …).
- `mvn test -pl ms-almacen` genera reporte en `target/site/jacoco/index.html`.
- Consolidado con activos y ventas: `02. Backend/docs/reporte-jacoco-activos-almacen-ventas.md`.
- Orquestación API + pruebas: `05. Documentacion/orquestacion/ORQUESTACION_MS-ALMACEN.md` (§ Pruebas automatizadas).

`testdata` en `main` queda fuera del camino de unitarios; la factory JDBC solo corre con `-Dalmacen.it=true`.

## Nota tenant dev

Si `GET /movimientos/{id}` o `ValeMovService.obtener` devuelve 500 por columna faltante en `articulo_mov_tipo` (p. ej. `cnta_cntbl`), aplicar migraciones Flyway del módulo en el tenant antes de exigir ese endpoint en IT.
