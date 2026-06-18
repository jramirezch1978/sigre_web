# Plan de Acción — Persona A (Recetas + Doc Técnica + Programación)

> ✅ **IMPLEMENTADO Y CORREGIDO.** 7 entidades, 37 archivos, `mvn compile` BUILD SUCCESS.

---

## Índice

- [Resumen Ejecutivo](#resumen-ejecutivo)
- [Correcciones Aplicadas](#correcciones-aplicadas)
- [Receta — Arquitectura](#1-receta--arquitectura)
- [Receta — Entidades](#2-receta--entidades)
- [Receta — DTOs](#3-receta--dtos)
- [Receta — Mappers + Repos](#4-receta--mappers--repos)
- [Receta — Endpoints](#5-receta--endpoints)
- [Receta — Validaciones](#6-receta--validaciones-vs-contrato)
- [Receta — Matriz Endpoint × Validación](#7-receta--matriz-endpoint--validación)
- [Doc Técnica — Arquitectura](#8-doc-técnica--arquitectura)
- [Doc Técnica — Endpoints + Validaciones](#9-doc-técnica--endpoints--validaciones)
- [Programación Producción](#10-programación-producción)
- [Error Codes](#11-produccionerrorcodes)
- [Errores — Ejemplos](#12-errores--ejemplos-de-respuesta)
- [Patrones](#13-patrones-y-decisiones-técnicas)
- [File Map](#14-mapa-de-archivos)
- [Tests + Deuda](#15-tests-pendientes--deuda-técnica)
- [Referencias](#16-referencias)

---

## Resumen Ejecutivo

| Componente | Archivos | Estado |
|---|---|---|
| Entidades JPA | 7 | ✅ |
| DTOs Request/Response | 7 + 9 | ✅ |
| Mappers MapStruct | 7 | ✅ |
| Repositories JPA | 7 | ✅ |
| Services (interfaces + impls) | 3 + 3 | ✅ |
| Controllers REST | 3 | ✅ |
| `ProduccionErrorCodes` | 52 constantes (20 son de Persona A) | ✅ |

**8 endpoints Receta** · **8 endpoints Doc Técnica** · **7 endpoints Programación** = **23 endpoints**

---

## Correcciones Aplicadas

| # | Issue | Síntoma | Fix |
|---|---|---|---|
| 1 | Joins nulos en responses | `articuloCodigo`, `laborCodigo`, `recetaHijaCodigo` siempre null | Batch enrichment JDBC IN queries |
| 2 | `nuevaVersion` rompía UNIQUE | No se podían crear 2 versiones del mismo código | `UNIQUE(codigo, version)` + PRD-RC-010 |
| 3 | Path doc técnica incorrecto | Contrato dice `/documentacion-tecnica` | Cambiado |
| 4 | `CaractDetResponse` incompleto | Faltaban `unidadMedidaCodigo` y `flagEstado` | Agregados al DTO + enrichment |
| 5 | PRD-DT-002 mal mapeado | Lanzaba PRD-DT-001 con 422 en vez de PRD-DT-002 con 404 | Corregido |
| 6 | PRD-DT-004 no validaba UM | No existía validación de FK a `core.unidad_medida` | Agregada en `guardarCaracteristicas` |
| 7 | PRD-DT-005: update permitía inactivos | No había check de `flagEstado` | Agregado |
| 8 | PRD-RC-007: secuencia duplicada | Labores con misma secuencia pasaban sin error | `Set<Integer>` en `guardarLabores` |
| 9 | Error codes inline | Strings hardcodeados en vez de constantes | Refactor a `ProduccionErrorCodes.*` |
| 10 | PRD-RC-009 no implementado | Se podía desactivar receta con programaciones activas | `validarSinProgramacionesActivas()` via JDBC |
| 11 | Path programación incorrecto | Contrato dice `/programaciones` | Cambiado |
| 12 | PRD-PP error codes mal mapeados | PRD-PP-001 usado para receta, PRD-PP-002 para fechas | Corregidos + agregados PP-003/004/005 |
| 13 | Programación sin enrichment | `recetaCodigo`, `ordenTrabajoCodigo` null siempre | `enrichResponses()` con 3 JDBC batch queries |
| 14 | Programación sin validaciones OT/sucursal/frecuencia | No existían | Agregadas |

---

## 1. Receta — Arquitectura

```
RecetaController (@RequestMapping /api/produccion/recetas)
  │
  ├── RecetaService (interface) ──→ RecetaServiceImpl
  │     ├── CRUD: create / update / activate / deactivate / nuevaVersion / delete
  │     ├── Sub-recursos: findLabores / findConsumibles / findFichaTecnica
  │     └── Enrichment: enrichRecetaResponses / enrichLaborResponses / enrichConsumibleResponses
  │
  ├── RecetaMapper           request → entity, entity → response
  ├── RecetaLaborMapper      request → entity, entity → response
  ├── RecetaConsumibleMapper request → entity, entity → response
  └── FichaTecnicaMapper     request → entity, entity → response
```

**Transacciones:** `create`, `update`, `activate`, `deactivate`, `nuevaVersion`, `delete` tienen `@Transactional`. Los métodos de solo lectura usan `readOnly = true`.

**Sincronización de hijos en update:** DELETE + INSERT (reemplazo total). Si falla el INSERT, el DELETE se revierte por la tx.

**nuevaVersion:** copia cabecera + labores + consumibles + ficha técnica, version incrementada, source → inactivo.

---

## 2. Receta — Entidades

### `Receta extends BaseEntity`

| Columna | Tipo | PK/UK | FK | Nullable |
|---|---|---|---|---|
| `articulo_producido_id` | `Long` | — | `core.articulo.id` | NO |
| `codigo` | `String(30)` | UK(codigo+version) | — | NO |
| `nombre` | `String(200)` | — | — | NO |
| `version` | `Integer` | UK(codigo+version) | — | NO (default 1) |
| `tipo` | `String(30)` | — | — | NO (default "PLATO") |
| `rendimiento_esperado` | `BigDecimal(18,4)` | — | — | SÍ |
| `porcentaje_merma` | `BigDecimal(8,4)` | — | — | SÍ |
| `costo_mano_obra` | `BigDecimal(18,4)` | — | — | SÍ (default 0) |
| `costo_indirecto` | `BigDecimal(18,4)` | — | — | SÍ (default 0) |
| `costo_total_estimado` | `BigDecimal(18,4)` | — | — | SÍ (default 0) |

### `RecetaLabor extends AuditOnlyMappedEntity`

| Columna | Tipo | FK | Nullable |
|---|---|---|---|
| `receta_id` | `Long` | `receta.id` | NO |
| `labor_id` | `Long` | `produccion.labor.id` | NO |
| `secuencia` | `Integer` | — | NO |
| `descripcion_paso` | `String` | — | SÍ |

### `RecetaLaborConsumible extends AuditOnlyMappedEntity`

| Columna | Tipo | FK | Nullable |
|---|---|---|---|
| `receta_padre_id` | `Long` | `receta.id` | NO |
| `receta_hija_id` | `Long` | `receta.id` | NO |
| `cantidad` | `BigDecimal(18,4)` | — | NO |

### `FichaTecnica extends AuditOnlyMappedEntity`

13 campos nutricionales: alergenos, calorias, proteinas_g, carbohidratos_g, grasas_g, fibra_g, sodio_mg, tipo_dieta, foto_presentacion_url, instrucciones_emplatado, tiempo_preparacion_min, tiempo_coccion_min, temperatura_servicio. Todos opcionales.

---

## 3. Receta — DTOs

### Request

| DTO | Campos | Validaciones clave |
|---|---|---|
| `RecetaRequest` | 11 campos (articuloProducidoId, codigo, nombre, tipo, rendimientoEsperado, %merma, costoMO, costoIndirecto, labores[], consumibles[], fichaTecnica) | `@NotNull` articuloProducidoId, `@NotBlank @Size(max=30)` codigo, `@NotBlank @Size(max=200)` nombre |
| `RecetaLaborRequest` | laborId, secuencia, descripcionPaso | `@NotNull` laborId + secuencia |
| `RecetaConsumibleRequest` | recetaHijaId, cantidad | `@NotNull` ambos, `@Positive` cantidad |
| `FichaTecnicaRequest` | 13 campos (todos opcionales) | Sin validaciones |

### Response

`RecetaResponse`: 16 campos fijos + 3 nested (labores, consumibles, fichaTecnica).
`RecetaLaborResponse`: 5 campos (incl. laborCodigo + laborNombre — enrichment).
`RecetaConsumibleResponse`: 4 campos (incl. recetaHijaCodigo + recetaHijaNombre — enrichment).
`FichaTecnicaResponse`: 13 campos (mapeo directo, sin enrichment).

---

## 4. Receta — Mappers + Repos

### Mappers (MapStruct, `componentModel = "spring"`)

| Mapper | Métodos | Ignora en toEntity |
|---|---|---|
| `RecetaMapper` | `toEntity`, `toResponse`, `toResponseList`, `updateEntity` | id, flagEstado, audit |
| `RecetaLaborMapper` | `toEntity`, `toResponse`, `toResponseList` | id, recetaId, audit |
| `RecetaConsumibleMapper` | `toEntity`, `toResponse`, `toResponseList` | id, recetaPadreId, audit |
| `FichaTecnicaMapper` | `toEntity`, `toResponse` | id, recetaId, audit |

⚠️ **Warnings de compilación:** MapStruct reporta `unmapped target` para `articuloCodigo`, `laborCodigo`, `recetaHijaCodigo`, etc. Son **intencionales** — se pueblan vía enrichment en runtime.

### Repositories

| Repository | Custom Methods | Extiende |
|---|---|---|
| `RecetaRepository` | `existsByCodigoIgnoreCaseAndVersion`, `...AndIdNot` | `Jpa` + `JpaSpecificationExecutor` |
| `RecetaLaborRepository` | `findByRecetaIdOrderBySecuenciaAsc`, `deleteByRecetaId` | `JpaRepository` |
| `RecetaLaborConsumibleRepository` | `findByRecetaPadreIdOrderByIdAsc`, `deleteByRecetaPadreId` | `JpaRepository` |
| `FichaTecnicaRepository` | `findByRecetaId`, `deleteByRecetaId` | `JpaRepository` |

---

## 5. Receta — Endpoints

| Método | Ruta | Status | Enrichment |
|---|---|---|---|
| GET | `/api/produccion/recetas?codigo&nombre&tipo&flagEstado&articuloProducidoId` | 200 | ✅ receta |
| GET | `/api/produccion/recetas/{id}` | 200 | ✅ receta + labor + consumible |
| POST | `/api/produccion/recetas` | 201 | ✅ receta |
| PUT | `/api/produccion/recetas/{id}` | 200 | ✅ receta |
| PATCH | `/api/produccion/recetas/{id}/activar` | 200 | ✅ receta |
| PATCH | `/api/produccion/recetas/{id}/desactivar` | 200 | ✅ receta |
| POST | `/api/produccion/recetas/{id}/nueva-version` | 201 | ✅ receta |
| DELETE | `/api/produccion/recetas/{id}` | 200 | ❌ (baja lógica, solo boolean) |

**Specification dinámica:** combina predicates con AND para cada filtro opcional.

---

## 6. Receta — Validaciones vs Contrato

| Código | HTTP | Contrato | Implementación |
|---|---|---|---|
| PRD-RC-001 | 400 | Datos incompletos | `@Valid` Jakarta Validation |
| PRD-RC-002 | 422 | Artículo inexistente | `validarArticuloProducido()`: JDBC `core.articulo WHERE id=? AND flag_estado='1'` |
| PRD-RC-003 | 409 | Código duplicado | `existsByCodigoIgnoreCaseAndVersion(codigo, 1)` |
| PRD-RC-004 | 422 | Labor inexistente | `validarLabor()`: JDBC `produccion.labor WHERE id=? AND flag_estado='1'` |
| PRD-RC-005 | 422 | Receta hija inexistente | `validarRecetaHija()`: JDBC `produccion.receta WHERE id=?` |
| PRD-RC-006 | 422 | Referencia circular | Check `recetaPadreId.equals(recetaHijaId)` |
| PRD-RC-007 | 409 | Secuencia duplicada | `Set<Integer>` en `guardarLabores()` |
| PRD-RC-008 | 422 | Receta inactiva | `if ("0".equals(existing.getFlagEstado()))` en update |
| PRD-RC-009 | 422 | Programaciones activas | `validarSinProgramacionesActivas()`: JDBC `produccion.programacion_produccion WHERE receta_id=? AND flag_estado='1'` |
| PRD-RC-010 | 409 | Versión existente | `existsByCodigoIgnoreCaseAndVersion(codigo, nuevaVersion)` |

---

## 7. Receta — Matriz Endpoint × Validación

| Endpoint | findById | existsBy | valArticulo | valLabor | valHija | checkSecuencia | checkInactivo | calcCosto | syncHijos | enrich |
|---|---|---|---|---|---|---|---|---|---|---|
| GET / | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| GET /{id} | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅✅✅ |
| POST / | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ |
| PUT /{id} | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| activar | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| desactivar | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| nueva-version | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ |
| DELETE | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |

---

## 8. Doc Técnica — Arquitectura

```
DocTecnicaController (@RequestMapping /api/produccion/documentacion-tecnica)
  │
  ├── ArticuloDocTecnicaService (interface) ──→ ArticuloDocTecnicaServiceImpl
  │     ├── CRUD + sub-recurso findCaracteristicas
  │     └── Enrichment: enrichCaractDetResponses
  │
  ├── ArticuloDocTecnicaMapper
  └── CaractDetMapper
```

**Entidades:**
- `ArticuloDocTecnica extends BaseEntity` — 5 campos (articuloId, tipoDocumento, nombreDocumento, archivoUrl, observacion)
- `ArticuloDocTecnicaCaractDet extends BaseEntity` — 4 campos (caracteristica, valor, unidadMedidaId)

Ambos con `BaseEntity` (tienen flagEstado), a diferencia de los hijos de Receta que usan `AuditOnlyMappedEntity`.

---

## 9. Doc Técnica — Endpoints + Validaciones

| Método | Ruta | Enrichment |
|---|---|---|
| GET | `/api/produccion/documentacion-tecnica` | ❌ (solo lista, sin joins) |
| GET | `/{id}` | ✅ CaractDet.unidadMedidaCodigo |
| POST | `/` | ✅ CaractDet.unidadMedidaCodigo |
| PUT | `/{id}` | ✅ CaractDet.unidadMedidaCodigo |
| PATCH | `/{id}/activar` | ❌ |
| PATCH | `/{id}/desactivar` | ❌ |
| DELETE | `/{id}` | ❌ (baja lógica) |
| GET | `/{id}/caracteristicas` | ✅ |

### Validaciones

| Código | HTTP | Contrato | Implementación |
|---|---|---|---|
| PRD-DT-001 | 400 | Incompleto | `@Valid` Jakarta Validation |
| PRD-DT-002 | 404 | Artículo inexistente | `validarArticulo()`: JDBC `core.articulo WHERE id=? AND flag_estado='1'` |
| PRD-DT-003 | 400 | Tipo documento inválido | **Pendiente** (requiere catálogo de tipos) |
| PRD-DT-004 | 404 | UM inexistente | `validarUnidadMedida()`: JDBC `core.unidad_medida WHERE id=?` |
| PRD-DT-005 | 422 | Inactivo | Check `flagEstado` en update |

---

## 10. Programación Producción

### Entidad

`ProgramacionProduccion extends BaseEntity` — 8 campos:

| Columna | Tipo | FK | Nullable |
|---|---|---|---|
| `sucursal_id` | `Long` | `auth.sucursal.id` | SÍ |
| `receta_id` | `Long` | `produccion.receta.id` | NO |
| `orden_trabajo_id` | `Long` | `produccion.orden_trabajo.id` | SÍ |
| `frecuencia` | `String(20)` | — | NO |
| `fecha_inicio` | `LocalDate` | — | NO |
| `fecha_fin` | `LocalDate` | — | SÍ |
| `cantidad_por_periodo` | `BigDecimal(18,4)` | — | NO |
| `turno` | `String(20)` | — | SÍ |

### Endpoints — `/api/produccion/programaciones`

| Método | Ruta | Enrichment |
|---|---|---|
| GET | `/` | ✅ recetaCodigo, recetaNombre, ordenTrabajoCodigo, sucursalNombre |
| GET | `/{id}` | ✅ |
| POST | `/` | ✅ |
| PUT | `/{id}` | ✅ |
| PATCH | `/{id}/activar` | ✅ |
| PATCH | `/{id}/desactivar` | ✅ |
| DELETE | `/{id}` | ❌ |

### Validaciones

| Código | HTTP | Contrato | Implementación |
|---|---|---|---|
| PRD-PP-001 | 400 | Request incompleto | `@Valid` Jakarta Validation |
| PRD-PP-002 | 404 | Receta inexistente | `validarReceta()`: JDBC `produccion.receta WHERE id=? AND flag_estado='1'` |
| PRD-PP-003 | 404 | OT inexistente | `validarOT()`: JDBC `produccion.orden_trabajo WHERE id=? AND flag_estado='1'` (solo si no null) |
| PRD-PP-004 | 404 | Sucursal inexistente | `validarSucursal()`: JDBC `auth.sucursal WHERE id=? AND flag_estado='1'` (solo si no null) |
| PRD-PP-005 | 400 | Frecuencia inválida | `validarFrecuencia()`: check contra Set {"DIARIA","SEMANAL","MENSUAL"} |

### Enrichment (3 JDBC batch queries)

- `recetaCodigo`, `recetaNombre` → `SELECT id, codigo, nombre FROM produccion.receta WHERE id IN (...)`
- `ordenTrabajoCodigo` → `SELECT id, codigo FROM produccion.orden_trabajo WHERE id IN (...)`
- `sucursalNombre` → `SELECT id, nombre FROM auth.sucursal WHERE id IN (...)`

### Dependencias

```
ProgramacionProduccion
  → produccion.receta        (FK receta_id, obligatorio, validado + enriquecido)
  → produccion.orden_trabajo (FK orden_trabajo_id, nullable, validado + enriquecido)
  → auth.sucursal            (FK sucursal_id, nullable, validado + enriquecido)
```

---

## 11. ProduccionErrorCodes

```java
// Labor:       PRD-LB-001 al 005     (5)
// Tipo OT:     PRD-OT-001 al 004     (4)
// Admin OT:    PRD-OA-001 al 005     (5)
// Receta:      PRD-RC-001 al 010     (10) ← Persona A
// Doc Técnica: PRD-DT-001 al 005     (5)  ← Persona A
// Prog. Prod:  PRD-PP-001 al 005     (5)  ← Persona A
// Parte Prod:  PRD-PT-001 al 008     (8)
// Control Cal: PRD-CC-001 al 005     (5)
// Costeo:      PRD-CP-001 al 005     (5)
// Operación:   PRD-OP-001            (1)
//                               Total: 52
```

20 constantes son de Persona A (RC 10 + DT 5 + PP 5).

---

## 12. Errores — Ejemplos de Respuesta

### 400 — Validación Jakarta
```json
{ "success": false, "errorCode": "VALIDATION_ERROR", "data": { "codigo": "no debe estar vacio" } }
```

### 409 — Código duplicado (PRD-RC-003)
```json
{ "success": false, "errorCode": "PRD-RC-003", "message": "Ya existe una receta con codigo REC-001" }
```

### 422 — Referencia circular (PRD-RC-006)
```json
{ "success": false, "errorCode": "PRD-RC-006", "message": "La receta no puede consumirse a si misma" }
```

### 422 — Receta inactiva (PRD-RC-008)
```json
{ "success": false, "errorCode": "PRD-RC-008", "message": "No se puede modificar una receta inactiva" }
```

---

## 13. Patrones y Decisiones Técnicas

| Decisión | Razón |
|---|---|
| **Enrichment via JDBC batch** (no JPA relationships) | Las entidades tienen solo IDs, no `@ManyToOne`. Batch IN query evita N+1. |
| **MapStruct warnings ignorados** | Campos enriquecidos no existen en la entidad. Son post-procesados. |
| **DELETE + INSERT en hijos** (no diff/merge) | Simplicidad. `@Transactional` revierte si falla. |
| **`UNIQUE(codigo, version)`** | Permite histórico. Versión anterior se desactiva automáticamente. |
| **Baja lógica (`flagEstado = '0'`)** | Consistente con todo el módulo common. |
| **Normalización:** `trim().toUpperCase()` código, `trim()` nombre | Evita duplicados por espacios/case. |
| **Specification dinámica** | Filtros opcionales sin SQL nativo. |
| **Enrichment en controller** (no en service) | El service es agnóstico de REST. El controller es el punto de entrada HTTP. |

---

## 14. Mapa de Archivos

```
controller/ (3)
├── RecetaController.java
├── DocTecnicaController.java
└── ProgramacionProduccionController.java

service/ (7)
├── RecetaService.java
├── ArticuloDocTecnicaService.java
├── ProgramacionProduccionService.java
├── impl/RecetaServiceImpl.java
├── impl/ArticuloDocTecnicaServiceImpl.java
├── impl/ProgramacionProduccionServiceImpl.java
└── ProduccionErrorCodes.java

entity/ (7)
├── Receta.java                          RecetaLabor.java
├── RecetaLaborConsumible.java           FichaTecnica.java
├── ArticuloDocTecnica.java              ArticuloDocTecnicaCaractDet.java
└── ProgramacionProduccion.java

dto/request/ (7)
├── RecetaRequest.java                   RecetaLaborRequest.java
├── RecetaConsumibleRequest.java         FichaTecnicaRequest.java
├── DocTecnicaRequest.java               CaractDetRequest.java
└── ProgramacionProduccionRequest.java

dto/response/ (9)
├── RecetaResponse.java                  RecetaLaborResponse.java
├── RecetaConsumibleResponse.java        FichaTecnicaResponse.java
├── DocTecnicaResponse.java              CaractDetResponse.java
├── ProgramacionProduccionResponse.java
├── PageData.java                        PageMeta.java

mapper/ (7)
├── RecetaMapper.java                    RecetaLaborMapper.java
├── RecetaConsumibleMapper.java          FichaTecnicaMapper.java
├── ArticuloDocTecnicaMapper.java        CaractDetMapper.java
└── ProgramacionProduccionMapper.java

repository/ (7)
├── RecetaRepository.java                RecetaLaborRepository.java
├── RecetaLaborConsumibleRepository.java FichaTecnicaRepository.java
├── ArticuloDocTecnicaRepository.java    CaractDetRepository.java
└── ProgramacionProduccionRepository.java
```

**Total: 37 archivos Java.**

---

## 15. Tests Pendientes + Deuda Técnica

### Tests

| Prioridad | Tests |
|---|---|
| Alta | `RecetaServiceImplTest`, `RecetaControllerTest`, `ArticuloDocTecnicaServiceImplTest`, `ArticuloDocTecnicaControllerTest`, `ProgramacionProduccionServiceImplTest`, `ProgramacionProduccionControllerTest` |
| Media | Mapper tests (7 mappers) |
| Baja | `PageDataTest` |

### Deuda Técnica

| Riesgo | Impacto |
|---|---|
| `PRD-DT-003` no implementado | Usuario puede poner cualquier string en `tipoDocumento` |
| Receta hija validada sin check de estado | Se puede referenciar receta inactiva como hija |
| DELETE + INSERT en hijos sin FK on delete | Si hay FKs reales apuntando, puede fallar |
| Enrichment en controller (no service) | Llamadas al service directas obtienen joins null |

---

## 16. Referencias

| Documento | Ruta |
|---|---|
| Contrato Receta | `05. Documentacion/.../CONTRATO_API_RECETA.md` |
| Contrato Doc Técnica | `05. Documentacion/.../CONTRATO_ARTICULO_DOC_TECNICA.md` |
| Contrato Programación | `05. Documentacion/.../CONTRATO_PROGRAMACION_PRODUCCION.md` |
| DDL Producción | `03. Base de datos/ddl/tenant/09-produccion.sql` |
| Error Codes | `service/ProduccionErrorCodes.java` |
| API Inventory | `docs/API_INVENTARIO.md` |
| Persona B | `docs/09_ACCION_PERSONA_B.md` |
