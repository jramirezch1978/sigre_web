# Tests — `ms-activos-fijos` (mismo patrón que `ms-almacen`)

> Documentación canónica: [`test-data-y-pruebas.md`](./test-data-y-pruebas.md) · Orquestación API: [`ORQUESTACION_MS-ACTIVOS-FIJOS.md`](../../../05.%20Documentacion/orquestacion/ORQUESTACION_MS-ACTIVOS-FIJOS.md) · JaCoCo conjunto: [`reporte-jacoco-activos-almacen-ventas.md`](../../docs/reporte-jacoco-activos-almacen-ventas.md).

## Estructura (igual que almacén)

| Pieza | Ubicación | Rol |
|-------|-----------|-----|
| `ActivosTestDataFactory` | `src/main/java/.../testdata/` | `@Component` JDBC idempotente sobre el tenant (`ensureActivosTransactionalData`) |
| `TestDataSeedService` + `TestDataAdminController` | `src/main/java/...` | Seed demo vía POST admin (no es la factory de tests) |
| `*ControllerTest` / `*ServiceImplTest` | `src/test/java/.../controller`, `service/` | Unitarios con **Mockito** |
| `*ControllerIT`, `ContabilidadIntegracionIT` | `src/test/java/.../integration/` | IT MockMvc / contabilidad (`-Dactivos.it=true`) |
| `ActivosTestDataFactorySmokeIT` | `src/test/java/.../testdata/` | IT contra BD real; deshabilitado por defecto |
| `support/` | `ControllerMockMvcFactory`, `ActivosTestSecurityConfig`, anotaciones IT | Infra compartida de tests |

## Factory — datos mínimos en BD (JDBC, sin Mockito)

Orden de inserción (idempotente):

1. `core.entidad_contribuyente` (proveedor demo)
2. `auth.sucursal` (bootstrap si falta tabla)
3. `activos.af_clase` → `af_sub_clase` → `af_ubicacion` (A y B) → `af_matriz_sub_clase`
4. `activos.af_maestro` → `af_maestro_cc_distrib` (si existe tabla + CC en contabilidad)
5. `af_calculo_cntbl`, `af_adaptacion` (+ det/dep), seguros (`af_aseguradora` → póliza → devengo), `af_traslado`, `af_historial`

Códigos estables (constantes en `ActivosTestDataFactory`): `CODIGO_SUCURSAL`, `CODIGO_CLASE`, `CODIGO_SUB_CLASE`, `CODIGO_UBICACION_A/B`, `CODIGO_MAESTRO`, `CODIGO_POLIZA`, `CODIGO_CC_1/2`.

No hay `ActivosTestDataFactoryTest` con mocks (mismo criterio que `ms-almacen`); validación contra BD: `ActivosTestDataFactorySmokeIT`.

## Cómo ejecutar

**Unitarios + smoke estructural (por defecto):**

```bat
cd c:\RESTAURANTPE\PROYECTOS\restpe-contabilidad-back-end\02. Backend
mvn test -pl ms-activos-fijos
```

**Solo smoke de controllers:**

```bat
mvn test -pl ms-activos-fijos -Dtest=MsActivosFijosSmokeTest
```

**Factory contra PostgreSQL del tenant** (requiere security + empresa enrutable, como almacén):

```bat
mvn test -pl ms-activos-fijos -Dtest=ActivosTestDataFactorySmokeIT -Dactivos.it=true
```

Reporte Surefire: `ms-activos-fijos/target/surefire-reports/`.
