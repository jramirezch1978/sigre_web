# Datos de prueba en `ms-ventas` — Estándar RESTPE

## Convención A / B / C

| Rol | Qué es | Dónde vive | Cuándo se usa |
|-----|--------|------------|---------------|
| **A** | Fachada JDBC compartida (`TestDataFactory` / `TestDataSeeder`) | `common` test-jar | Solo integration tests |
| **B** | Factory JDBC del microservicio (`VentasTestDataFactory`, `@Component` en `main`) | `src/main/java/.../testdata/` | Solo integration tests |
| **C** | Fixtures estáticas en RAM (`VentasTestFixtures`) | `src/test/java/.../VentasTestFixtures.java` | Unit tests; opcional como body JSON en IT |

**Reglas:**
- **A + B** → Solo en `@Tag("integration")` con `@SpringBootTest`
- **C** → Solo en tests unitarios con `@ExtendWith(MockitoExtension.class)`
- NUNCA mezclar A/B en tests unitarios
- NUNCA usar `@MockBean` de repos/services del propio MS en IT

## Mecanismos adicionales (legacy)

| Mecanismo | Ubicación | Uso |
|-----------|-----------|-----|
| **Seed admin** | `TestDataSeedService` + `POST /api/ventas/admin/test-data/seed` | Demo masiva en QA/local (`app.testdata.enabled`) |
| **VentasFase4TestDataFactory** (legacy) | `src/test/java/.../testdata/VentasFase4TestDataFactory.java` | Objetos en RAM (migrar a **C**) |

## Tests por capa

| Tipo | Ejemplo | Comando |
|------|---------|---------|
| Unitarios Mockito | `*ServiceImplTest`, `*ControllerTest`, `VentasFlowTest` | `cd "02. Backend"` → `mvn test -pl ms-ventas` o desde raíz: `test.bat ms-ventas` |
| Integración BD | `integration.*`, `VentasTestDataFactorySmokeIT` | `cd "02. Backend"` → `mvn test -pl ms-ventas -Dgroups=integration` |

## Estructura de carpetas en `src/test`

| Carpeta | Contenido |
|---------|-----------|
| `support/` | `VentasTestSecurityConfig` (seguridad perfil `test`) |
| `integration/` | Tests `@Tag("integration")` (antes `controller/integration`) |
| `controller/` | Tests unitarios de controladores |
| `service/` | Tests unitarios de servicios |
| `testdata/` | Factory estático (unitarios) e IT JDBC |

Perfil IT: `src/test/resources/application-test.yml` (PostgreSQL dev, Flyway off).

El `pom.xml` de ms-ventas excluye el grupo `integration` en `mvn test` estándar (igual que ms-compras).

## JaCoCo

- Gate Maven **≥ 80%** instrucciones (bundle ~81% tras ampliación de tests Mockito).
- Excludes: `entity`, `repository`, `dto`, `testdata`, `TestDataAdminController`, `config`, …
- Reporte HTML: `ms-ventas/target/site/jacoco/index.html`.
- Consolidado: `02. Backend/docs/reporte-jacoco-activos-almacen-ventas.md`.
- Orquestación: `05. Documentacion/orquestacion/ORQUESTACION_MS-VENTAS.md` (§ Pruebas automatizadas).

## Seed administrativo (resumen)

- **HTTP:** `POST /api/ventas/admin/test-data/seed`
- **Activación:** `app.testdata.enabled` / `APP_TESTDATA_ENABLED`
- Re-ejecución: limpia comandas, facturas, pagos y pedidos mesa antes de recrear PV/mesas demo.

## Constantes estables (factory JDBC)

- Punto de venta de fábrica: código `PV-TEST`
- Mesa comanda: `M-TEST-01`
- Cliente contribuyente id: `2`

### Dataset masivo (~120 filas por tabla)

`VentasTestDataFactoryBulk` (al final de `ensureVentasTransactionalData`) inserta **120 filas** idempotentes en todas las tablas `ventas` del DDL `04-ventas.sql`: zonas comerciales, PV `PVB*`, mesas `M-BULK-*`, comandas, facturas serie `BBL`, OV `OV-BULK-*`, proformas, CxC, reservas, cartas, etc. Constante: `VentasTestDataFactory.BULK_ROWS_PER_TABLE`.

IT extendido:

```bat
cd c:\RESTAURANTPE\PROYECTOS\restpe-contabilidad-back-end\02. Backend
mvn test -pl ms-ventas -Dventas.it=true -Dtest=VentasTestDataExtendedIT,VentasTestDataFactorySmokeIT
```

## Cuándo usar cada uno

| Necesidad | Usar |
|-----------|------|
| Demo masiva POS/ventas | Seed admin |
| CI local rápido (sin BD) | Solo unitarios + `VentasFlowTest` |
| Validar API contra PostgreSQL tenant | `-Dgroups=integration` |
| Producción | Ninguno sin proceso operativo explícito |
