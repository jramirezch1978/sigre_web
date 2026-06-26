# Plan de Trabajo en Paralelo — ms-rrhh (Dev 1)

> **✅ COMPLETADO: Los 9 items de este plan (8-16 menos Boleta Pago) fueron implementados.**
> Estado final: 38 controllers, **276 endpoints**, 38/38 módulos completos. Sin discrepancias pendientes.

## Objetivo

Dividir el desarrollo pendiente de ms-rrhh (items 8-16) respetando el orden de implementación definido y minimizando conflictos.

## Principio de División

Siguiendo el patrón de ms-produccion, se divide por grafo de dependencias:

```
Dev 1 (este plan): Items 8-16 en orden secuencial (1 persona)
```

A diferencia de ms-produccion donde había 2 personas, acá tenemos **1 desarrollador** que avanza secuencialmente. El plan está organizado en **fases** para maximizar el avance sin bloqueos.

## Orden de Implementación

| Orden | Item | Tipo | Dependencias | Archivos estimados |
|:-----:|:----:|------|--------------|:------------------:|
| 1 | 11 — Permiso/Licencia | Gestión | Trabajador | ~25 |
| 2 | 13 — Sanción/Amonestación | Gestión | Trabajador, Tipo Sanción | ~22 |
| 3 | 14 — Capacitación | Gestión | Trabajador | ~28 |
| 4 | 9 — Gratificación | Legal (batch) | Trabajador, Contrato, Período | ~20 |
| 5 | 10 — CTS | Legal (batch) | Trabajador, Contrato, Período | ~20 |
| 6 | 12 — Novedad RRHH | Gestión | Trabajador, Tipo Novedad | ~28 |
| 7 | 8 — Boleta Pago | Proceso | Cálculo Planilla (Dev 2) | ~22 |
| 8 | 15 — Cuenta Corriente | Financiero | Trabajador | ~25 |
| 9 | 16 — Préstamo | Financiero | Trabajador | ~22 |

**Total archivos a crear:** ~212 archivos Java (nuevos + modificar existentes)

## Mapa de Archivos Compartidos

Estos archivos se modifican (no se crean) en cada item:

| Archivo | Modificado por items |
|---------|:--------------------:|
| `RrhhErrorCodes.java` | Todos (agregar constantes) |
| `RrhhTestDataFactory.java` | Todos (agregar factory methods) |
| `RrhhTestFixtures.java` | Todos (agregar fixtures) |
| `TestDataSeederRrhh.java` | Todos (agregar seed) |
| `RrhhSecurityConfig.java` | Solo si aplica (rara vez) |

## Archivos que NADIE toca

| Archivo | Razón |
|---------|-------|
| `pom.xml` | Sin nuevas dependencias externas |
| `application.yml` | Sin cambios de configuración |
| `Dockerfile` | Sin cambios |
| `RrhhSecurityConfig.java` | Sin cambios (ya protege `/api/rrhh/**`) |

## Patrón de Implementación por Item

Cada item sigue exactamente el mismo patrón. Ejemplo con Permiso/Licencia (Item 11):

```
1. Constants        → PermisoLicenciaConstants.java
2. Entity           → PermisoLicencia.java
3. Repository       → PermisoLicenciaRepository.java
4. DTOs Request     → PermisoLicenciaCreateRequest.java, PermisoLicenciaUpdateRequest.java
5. DTOs Response    → PermisoLicenciaResponse.java
6. Mapper           → PermisoLicenciaMapper.java
7. Specification    → PermisoLicenciaSpecification.java  (si aplica)
8. Validator        → PermisoLicenciaValidator.java
9. Service          → PermisoLicenciaService.java + PermisoLicenciaServiceImpl.java
10. Controller      → PermisoLicenciaController.java
11. Factory B       → modificar RrhhTestDataFactory
12. Fixtures C      → modificar RrhhTestFixtures
13. Seed            → modificar TestDataSeederRrhh
14. Unit tests      → Constants, Mapper, Validator, Specification, Service
15. Integration test → Controller
```

## Detalle por Fase

### Fase 1 — Gestión de Personal (Items 11 → 13 → 14)

**Item 11 — Permiso/Licencia** (~25 archivos)
- Entidades: `permiso_licencia` (ya en DDL)
- Tablas adicionales: `tipo_suspension_laboral` (catálogo)
- Endpoints: 7 (GET list, GET/{id}, POST, PUT, POST aprobar, POST rechazar, PATCH desactivar)
- Reglas: aprobación/rechazo, flujo de estado, solapamiento de fechas
- Dependencias: Trabajador (existente), TipoSuspensionLaboral (crear catálogo)

**Item 13 — Sanción/Amonestación** (~22 archivos)
- Entidades: `sancion_amonestacion`, `tipo_sancion` (ya en DDL)
- Endpoints: 5 (GET list, GET/{id}, POST, PUT, PATCH desactivar)
- Reglas: no modificar después de aplicar descuento, fechas no futuras
- Dependencias: Trabajador, TipoSancion (crear catálogo)

**Item 14 — Capacitación** (~28 archivos)
- Entidades: `capacitacion`, `capacitacion_trabajador` (ya en DDL)
- Endpoints: 8 (CRUD capacitación + CRUD participantes sub-recurso)
- Reglas: participante duplicado, fechas válidas
- Dependencias: Trabajador

### Fase 2 — Beneficios Legales (Items 9 → 10)

**Item 9 — Gratificación** (~20 archivos)
- Entidades: `gratificacion`, `periodo_gratificacion` (ya en DDL)
- Endpoints: 3 (POST procesar, GET list, GET/{id})
- Lógica batch: cálculo de gratificación según Ley 27735
- Dependencias: Trabajador, Contrato (datos de remuneración)

**Item 10 — CTS** (~20 archivos)
- Entidades: `cts`, `periodo_cts` (ya en DDL)
- Endpoints: 3 (POST procesar, GET list, GET/{id})
- Lógica batch: cálculo de CTS según norma laboral
- Dependencias: Trabajador, Contrato

### Fase 3 — Novedades (Item 12)

**Item 12 — Novedad RRHH** (~28 archivos)
- Entidades: `novedad_rrhh`, `novedad_rrhh_det` (ya en DDL)
- Endpoints: 9 (CRUD novedad + CRUD detalle sub-recurso)
- Reglas: no duplicar en período, no desactivar si está en planilla
- Dependencias: Trabajador, TipoNovedadRrhh (existente)

### Fase 4 — Procesos y Financiero (Items 15 → 16)

**Item 8 — Boleta Pago** ❌ **ELIMINADO**
- Funcionalidad descartada. La tabla `boleta_pago` y sus archivos Java fueron eliminados del DDL y del código fuente.

**Item 15 — Cuenta Corriente** (~25 archivos)
- Entidades: `cnta_crrte`, `cnta_crrte_det`, `tipo_movimiento_cnta_crrte` (ya en DDL)
- Endpoints: 7 (GET list, GET/{id}, POST, PUT, PATCH estado, GET movimientos, POST movimientos)
- Reglas: cuenta única por trabajador, no cerrar con saldo

**Item 16 — Préstamo** (~22 archivos)
- Entidades: `prestamo` (ya en DDL)
- Endpoints: 5 (GET list, GET/{id}, POST, PUT, PATCH estado)
- Reglas: no modificar si hay cuotas descontadas, estado ACTIVO/CANCELADO

## Resumen de Carga

| Fase | Items | Archivos nuevos | Tipo |
|:----:|:-----:|:--------------:|------|
| 1 | 11, 13, 14 | ~75 | Gestión (CRUD) |
| 2 | 9, 10 | ~40 | Legal (batch) |
| 3 | 12 | ~28 | Gestión (CRUD + detalle) |
| 4 | 8, 15, 16 | ~69 | Proceso/Financiero |
| **Total** | **9** | **~212** | |

## Convenio de Interfaces

- **DTOs compartidos**: Definir en el package correspondiente, reutilizar `TrabajadorResponse` existente
- **Nombres de endpoints**: `/api/rrhh/{recurso}` en plural
- **Prefijo de errores**: `RH-{DOMINIO}-*` documentado en reglas de negocio
- **Patrón de código**: idéntico al existente (ApiResponse, @Timed, @Transactional, baja lógica)
- **Catálogos**: Los catálogos faltantes (tipo_sancion, tipo_suspension_laboral, etc.) se implementan junto con el item que los necesita
