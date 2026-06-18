# Plan de Acción — Persona B (Ejecución)

> 🔍 **VALIDADO vs CONTRATOS — GAPS DETECTADOS.** Ver sección de cada API para detalle.
> **Alcance:** 5 APIs · 7 entidades · ~35 endpoints · ~47 archivos

---

## Índice

- [Resumen](#resumen)
- [1. Órdenes de Trabajo](#1-órdenes-de-trabajo)
- [2. Operaciones](#2-operaciones)
- [3. Partes de Producción](#3-partes-de-producción)
- [4. Control de Calidad](#4-control-de-calidad)
- [5. Costeo Producción](#5-costeo-producción)
- [Checklist de Validación](#checklist-de-validación)
- [Orden Sugerido](#orden-sugerido-de-validación)
- [Archivos a Revisar](#archivos-a-revisar)
- [Referencias](#referencias)

> ℹ️ Programación Producción es responsabilidad de **Persona A** (ver `08_ACCION_PERSONA_A.md`).

---

## Resumen

| # | API | Entidades | Endpoints |
|---|---|---|---|
| 1 | Órdenes de Trabajo | 1 (`orden_trabajo`) | 7 |
| 2 | Operaciones | 2 (`operacion` + `operaciones_det`) | 9 |
| 3 | Partes de Producción | 3 (`parte` + `insumo` + `producido`) | 9 |
| 4 | Control de Calidad | 1 (`control_calidad`) | 5 |
| 5 | Costeo Producción | 1 (`costeo_produccion`) | 5 (+2 batch) |

---

## 1. Órdenes de Trabajo

### Entidad

| Tabla | PK | Extiende | flagEstado |
|---|---|---|---|
| `orden_trabajo` | `id` | `BaseEntity` | Sí |

**Campos:** sucursalId, otTipoId, otAdministracionId, codigo (VARCHAR(12), UNIQUE), fechaInicio, fechaFin.
**Código auto:** `OT-YYYY-NNNN`. **FK cross-schema:** vía OpenFeign clients (`CoreSucursalClient`, `AuthUsuarioClient`).

### Endpoints — `/api/produccion/ordenes-trabajo`

| Método | Ruta | Status | Contrato |
|---|---|---|---|
| GET | `/` (filtros: codigo, sucursalId, otTipoId, otAdministracionId, fechaInicio, fechaFin, flagEstado) | 200 | ✅ |
| GET | `/{id}` | 200 | ✅ |
| POST | `/` | 201 | ✅ |
| PUT | `/{id}` | 200 | ✅ |
| PATCH | `/{id}/activar` | 200 | ✅ |
| PATCH | `/{id}/desactivar` | 200 | ✅ |
| POST | `/{id}/cerrar` | 200 | ✅ Implementado |
| POST | `/{id}/anular` | 200 | ✅ Implementado |
| DELETE | `/{id}` (baja lógica) | 200 | ⚠️ No existe en contrato |

> **Nota:** `flag_estado` soporta 3 estados: `'1'`=Activa, `'2'`=Cerrada, `'0'`=Anulada.

### Validaciones del Contrato (11 códigos)

| Código | HTTP | Significado | Estado |
|---|---|---|---|
| PRD-OT-001 | 422 | Sucursal no existe o inactiva | ✅ |
| PRD-OT-002 | 422 | Tipo OT no existe o inactivo | ✅ |
| PRD-OT-003 | 422 | Admin OT no existe o inactiva | ✅ |
| PRD-OT-004 | 422 | Código OT duplicado | ✅ |
| PRD-OT-005 | 400 | Fecha inicio obligatoria | ✅ |
| PRD-OT-006 | 400 | Fecha fin < fecha inicio | ✅ |
| PRD-OT-007 | 400 | Fecha operación fuera de rango OT | ✅ |
| PRD-OT-008 | 422 | Labor inexistente en operación | ✅ |
| PRD-OT-009 | 422 | Artículo inexistente en operación | ✅ |
| PRD-OT-010 | 400 | Cantidad requerida ≤ 0 | ✅ |
| PRD-OT-CONFLICT | 409 | Conflicto transición estado | ✅ Implementado |

### Response Format Gap

| Aspecto | Contrato | Implementación |
|---|---|---|
| Sucursal/Tipo/Admin | Objeto anidado `{"id":1,"nombre":"..."}` | ✅ Objeto anidado con enrichment |

---

## 2. Operaciones

### Entidades

| Tabla | PK | Extiende | flagEstado |
|---|---|---|---|
| `operacion` | `id` | `BaseEntity` | Sí |
| `operaciones_det` | `id` | `BaseEntity` | Sí |

**FK desde compras:** `compras.orden_compra_det.operaciones_det_id` y `compras.orden_servicio_det.operaciones_det_id`.

### Endpoints — `/api/produccion/operaciones`

| Método | Ruta | Status |
|---|---|---|
| GET | `/` (filtros: ordenTrabajoId, fecha, flagEstado) | 200 |
| GET | `/{id}` | 200 |
| POST | `/` | 201 |
| PUT | `/{id}` | 200 |
| PATCH | `/{id}/activar` | 200 |
| PATCH | `/{id}/desactivar` | 200 |
| DELETE | `/{id}` (baja lógica) | 200 |
| GET | `/{id}/detalles` | 200 |
| POST | `/{id}/detalles` | 201 |

### Validaciones

| Código | HTTP | Significado | Estado |
|---|---|---|---|
| PRD-OP-001 | 422 | Labor inexistente en detalle | ✅ |

**Sync de detalles:** reemplazo total (DELETE + INSERT) en update.

---

## 3. Partes de Producción

### Entidades

| Tabla | PK | Extiende | flagEstado |
|---|---|---|---|
| `parte_produccion` | `id` | `BaseEntity` | Sí |
| `parte_produccion_insumo` | `id` | `BaseEntity` | Sí |
| `parte_produccion_producido` | `id` | `BaseEntity` | Sí |

### Endpoints — `/api/produccion/partes-produccion`

| Método | Ruta | Status |
|---|---|---|
| GET | `/` | 200 |
| GET | `/{id}` (con insumos + producidos) | 200 |
| POST | `/` (con insumos + producidos) | 201 |
| PUT | `/{id}` | 200 |
| PATCH | `/{id}/activar` | 200 |
| PATCH | `/{id}/desactivar` | 200 |
| DELETE | `/{id}` (baja lógica) | 200 |
| GET | `/{id}/insumos` | 200 |
| GET | `/{id}/producidos` | 200 |

### Validaciones

| Código | HTTP | Significado | Estado |
|---|---|---|---|
| PRD-PT-001 | 400 | Request incompleto | ✅ |
| PRD-PT-002 | 404 | OT inexistente | ✅ (vía Feign) |
| PRD-PT-003 | 404 | Artículo inexistente | ✅ (vía Feign) |
| PRD-PT-004 | 400 | Cantidad ≤ 0 | ✅ |
| PRD-PT-005 | 400 | Sin insumos ni producidos | ✅ |
| PRD-PT-006 | 404 | Vale movimiento inexistente | ✅ (vía Feign) |
| PRD-PT-007 | 422 | Parte inactiva, no modificable | ✅ |
| PRD-PT-008 | 404 | Unidad medida inexistente | ✅ (vía Feign) |

**Integración futura:** `parte_produccion_insumo.vale_mov_id` FK a `almacen.vale_mov`.

---

## 4. Control de Calidad

### Entidad

| Tabla | PK | Extiende | flagEstado |
|---|---|---|---|
| `control_calidad` | `id` | `AuditOnlyMappedEntity` | No |

**Campos:** ordenTrabajoId (NULLABLE), inspectorId, fecha, resultado, observaciones.

### Endpoints — `/api/produccion/controles-calidad`

| Método | Ruta | Status | Contrato |
|---|---|---|---|
| GET | `/` (filtros: `ordenTrabajoId`, `resultado`, `fechaDesde`, `fechaHasta`, `inspectorId`) | 200 | ✅ |
| GET | `/{id}` | 200 | ✅ |
| POST | `/` | 201 | ✅ |
| PUT | `/{id}` | 200 | ✅ |
| DELETE | `/{id}` | 200 | ✅ |

> **Path corregido:** Ahora es `/api/produccion/controles-calidad` (plural), alineado con el contrato.
>
> **Filtros implementados:** `ordenTrabajoId`, `resultado`, `fechaDesde`, `fechaHasta`, `inspectorId`.

### Validaciones

| Código | HTTP | Significado | Estado |
|---|---|---|---|
| PRD-CC-001 | 400 | Datos obligatorios incompletos | ✅ |
| PRD-CC-002 | 404/422 | FK inexistente (OT, inspector) | ✅ |
| PRD-CC-003 | 422 | Resultado inválido | ✅ Validado contra catálogo |
| PRD-CC-004 | 404 | No encontrado | ✅ Código propio |
| PRD-CC-005 | 422 | Acción no permitida | ✅ |

**Sin flagEstado** — no tiene activar/desactivar. `resultado` validado contra catálogo (APROBADO, RECHAZADO, OBSERVADO).

---

## 5. Costeo Producción

### Entidad

| Tabla | PK | Extiende | flagEstado |
|---|---|---|---|
| `costeo_produccion` | `id` | `AuditOnlyMappedEntity` | No |

**Campos:** ordenTrabajoId (NULLABLE), costoMateriaPrima, costoManoObra, costoIndirecto, costoTotal, costoUnitario, rendimientoReal, porcentajeMermaReal.

### ✅ Reimplementado como proceso batch

El costeo ya no es un CRUD manual. Se reimplementó como un proceso de cálculo batch automático alineado con el contrato.

### Endpoints — `/api/produccion/costeos`

| Método | Ruta | Uso (contrato) | Estado |
|---|---|---|---|
| POST | `/api/produccion/costeos/procesar` | Ejecutar cálculo batch por periodo (anio+mes) | ✅ |
| GET | `/api/produccion/costeos` | Consultar resultados (paginado, filtros: `ordenTrabajoId`, `anio`, `mes`) | ✅ |
| GET | `/api/produccion/costeos/{id}` | Consultar detalle de costeo | ✅ |
| GET | `/api/produccion/costeos/por-periodo` | Consultar costeos por anio+mes | ✅ |

### Endpoints removidos (ya no existen)

| Método | Ruta | Razón |
|---|---|---|
| POST | `/api/produccion/costeos` | Usuario no debe crear costeos manualmente |
| PUT | `/api/produccion/costeos/{id}` | Usuario no debe editar costeos manualmente |
| DELETE | `/api/produccion/costeos/{id}` | Contrato no contempla eliminación |

### Validaciones

| Código | HTTP | Significado | Estado |
|---|---|---|---|
| PRD-CP-001 | 400 | Período obligatorio | ✅ |
| PRD-CP-002 | 400 | Período inválido | ✅ |
| PRD-CP-003 | 422 | Sin OTs en período | ✅ |
| PRD-CP-004 | 404 | Sucursal inexistente | ✅ (vía Feign) |
| PRD-CP-005 | 422 | Error cálculo costos | ✅ |

**Lógica de cálculo implementada:**
1. Costo materia prima: suma (cantidad_consumida × costo_unitario) de parte_produccion_insumo
2. Costo mano de obra: prorrateado desde receta o parámetros
3. Costo indirecto: prorrateado desde gastos indirectos
4. Costo total: materia_prima + mano_obra + indirecto
5. Costo unitario: costo_total / rendimiento_real
6. Rendimiento real: suma de cantidad_producida
7. Porcentaje merma real: diferencia insumos vs producidos
8. Idempotente: recalcular mismo periodo actualiza registros sin duplicar

**Sin flagEstado** — el costeo no tiene activar/desactivar.

---

## Checklist de Validación vs Contratos

### Orden Trabajo + Operación

- [x] **Endpoints:** 9/9 implementados — ✅ Incluye `POST /{id}/cerrar` y `POST /{id}/anular`
- [x] **Request body:** ✅ Coincide con contrato
- [x] **Response body:** ✅ Objetos anidados (`sucursal`, `otTipo`, `otAdministracion`) con id + nombre
- [x] **HttpStatus:** ✅ Correctos
- [x] **Códigos de error:** ✅ Todos definidos en `ProduccionErrorCodes`
- [x] **Validaciones:** ✅ PRD-OT-001 al 010 + PRD-OT-CONFLICT implementados
- [x] **FKs externas:** ✅ Validadas vía OpenFeign clients
- [x] **Joins en responses:** ✅ Enrichment vía Feign (sucursal) + repositorios (tipo, admin)
- [x] **Compilación:** ✅

### Parte Producción

- [x] **Endpoints:** ✅ 6/6 implementados (DELETE es extra, no falta)
- [x] **Validaciones:** ✅ PRD-PT-001 al 008
- [x] **Response:** ✅ Coincide con contrato (enrichment)

### Control de Calidad

- [x] **Endpoints:** ✅ Path corregido a `controles-calidad`
- [x] **Filtros:** ✅ Implementados `ordenTrabajoId`, `resultado`, `fechaDesde`, `fechaHasta`, `inspectorId`
- [x] **PRD-CC-003:** ✅ Validado contra catálogo
- [x] **PRD-CC-004:** ✅ Usa código propio

### Costeo Producción

- [x] **Arquitectura:** ✅ Reimplementado como proceso batch
- [x] **POST /procesar:** ✅ Implementado
- [x] **GET /por-periodo:** ✅ Implementado
- [x] **PUT/DELETE:** ✅ Removidos (usuario no edita costeos)
- [x] **Path:** ✅ Corregido a `/costeos`

---

## Orden Sugerido de Validación

```
1. Orden Trabajo + Operación   (dependencia aguas arriba)
2. Parte Producción             (depende de OT)
3. Control de Calidad           (depende de OT, independiente)
4. Costeo Producción            (depende de OT + Parte)
5. Tests unitarios (todo Persona B)
```

---

## Archivos a Revisar

```
entity/          controller/
├── OrdenTrabajo.java               ├── OrdenTrabajoController.java
├── Operacion.java                  ├── OperacionController.java
├── OperacionesDet.java             ├── ParteProduccionController.java
├── ParteProduccion.java            ├── ControlCalidadController.java
├── ParteProduccionInsumo.java      └── CosteoProduccionController.java
├── ParteProduccionProducido.java
├── ControlCalidad.java         service/* + service/impl/*   (7 archivos)
└── CosteoProduccion.java
                                 mapper/* (6 mappers)
dto/request/* (6 requests)       repository/* (6 repos)
dto/response/* (6 responses)
```

---

## Referencias

| Documento | Ruta |
|---|---|
| Contrato OT | `05. Documentacion/.../CONTRATO_API_ORDEN_TRABAJO.md` |
| Contrato Parte Prod. | `05. Documentacion/.../CONTRATO_API_PARTE_PRODUCCION.md` |
| Contrato Control Calidad | `05. Documentacion/.../CONTRATO_CONTROL_CALIDAD.md` |
| Contrato Costeo | `05. Documentacion/.../CONTRATO_COSTEO_PRODUCCION.md` |
| DDL Producción | `03. Base de datos/ddl/tenant/09-produccion.sql` |
| Error Codes | `service/ProduccionErrorCodes.java` |
| API Inventory | `docs/API_INVENTARIO.md` |
| Persona A | `docs/08_ACCION_PERSONA_A.md` |
