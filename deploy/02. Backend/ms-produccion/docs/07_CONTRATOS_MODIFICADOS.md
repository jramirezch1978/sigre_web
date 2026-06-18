# Contratos Modificados — ms-produccion

> **Generado:** 27/05/2026
> **Propósito:** Resumen de cambios en contratos existentes, commit por commit.
> Los archivos **nuevos** (creados una sola vez) no se listan aquí; solo los que recibieron modificaciones después de su creación.

---

## 1. Orden de Trabajo — 2 modificaciones

### 1.1 `90263d99` — JSON completos y estructura formal

**Archivos:**
- `05. Documentacion/markdown/Contratos/ms-produccion/CONTRATO_API_ORDEN_TRABAJO.md`

**Endpoints afectados:**
- `GET /api/produccion/ordenes-trabajo` — response cambia de IDs planos a objetos anidados
- `GET /api/produccion/ordenes-trabajo/{id}` — idem
- `POST /api/produccion/ordenes-trabajo` — body completo + response anidado
- `PUT /api/produccion/ordenes-trabajo/{id}` — se agrega lógica de sincronización

**Cambios:**
- Borrador mínimo (~51 líneas) → contrato completo (~445 líneas)
- Catálogo de errores `PRD-OT-001` al `PRD-OT-010`
- Endpoint **PUT** con lógica de sincronización de detalles (insert/update/delete)
- Responses con objetos anidados (`"sucursal": {"id": 1, "nombre": "..."}`) en vez de IDs planos
- Ejemplos actualizados de panadería a restaurante

### 1.2 `5ae919ff` — Cambios DDL en operacion y operaciones_det

**Archivos:**
- `05. Documentacion/markdown/Contratos/ms-produccion/CONTRATO_API_ORDEN_TRABAJO.md`
- `05. Documentacion/markdown/Contratos/ms-produccion/HU_ORDEN_TRABAJO.md`

**Endpoints afectados:**
- `GET /api/produccion/ordenes-trabajo/{id}` — estructura de `operaciones[]` cambia (15+ campos nuevos)
- `POST /api/produccion/ordenes-trabajo` — body de `operaciones[]` expandido
- `PUT /api/produccion/ordenes-trabajo/{id}` — idem

**Cambios:**
- `operacion.fecha` eliminado, reemplazado por **15+ campos nuevos**: `nro_operacion`, `labor_id`, `ejecutor_id`, `entidad_contribuyente_id`, `centros_costo_id`, `unidad_medida_id`, `descripcion`, `nro_personas`, fechas estimadas, duración, cantidades, costos
- `operaciones_det` pierde `labor_id` y `unidad_medida_id` (pasan a nivel operación)
- Nuevos códigos de error: `PRD-OT-009` al `PRD-OT-016`, `PRD-OT-ANULAR-VALE`, `PRD-OT-ANULAR-OC`

---

## 2. Receta — 1 modificación

### `6139a195` — Renombre de campos y eliminación de versionamiento

**Archivos:**
- `05. Documentacion/markdown/Contratos/ms-produccion/CONTRATO_API_RECETA.md`
- `05. Documentacion/markdown/Contratos/ms-produccion/HU_RECETA.md`

**Endpoints afectados:**
- `GET /api/produccion/recetas` — response: `codigo` → `nroReceta`, `tipo` → `flagTipoReceta`
- `GET /api/produccion/recetas/{id}` — idem + consumibles: `recetaHijaId` → `articuloId`, nuevo `tieneFotoBlob`
- `POST /api/produccion/recetas` — body: `codigo` → `nroReceta`, `tipo` → `flagTipoReceta`
- `PUT /api/produccion/recetas/{id}` — idem
- **Eliminado** `POST /api/produccion/recetas/{id}/nueva-version`

**Cambios:**
- `codigo` → `nroReceta`
- `tipo` (string) → `flagTipoReceta` (char) con catálogo `P/B/G/S/D/E/I`
- **Eliminado** endpoint `POST /{id}/nueva-version`
- `recetaHijaId` → `articuloId` en consumibles (se elimina referencia circular)
- Nuevo campo `tieneFotoBlob: boolean` en ficha técnica

---

## 3. Documentación Técnica — 2 modificaciones

### 3.1 `83dc4a41` — FK doc_tipo_id en vez de tipo_documento

**Archivos:**
- `05. Documentacion/markdown/Contratos/ms-produccion/CONTRATO_ARTICULO_DOC_TECNICA.md`
- `05. Documentacion/markdown/Contratos/ms-produccion/HU_ARTICULO_DOC_TECNICA.md`

**Endpoints afectados:**
- `GET /api/produccion/documentacion-tecnica` — response: `tipoDocumento` → `docTipoId` + `docTipoCodigo` + `docTipoNombre`
- `GET /api/produccion/documentacion-tecnica/{id}` — idem
- `POST /api/produccion/documentacion-tecnica` — body: `tipoDocumento` → `docTipoId`
- `PUT /api/produccion/documentacion-tecnica/{id}` — idem

**Cambios:**
- `tipoDocumento` (VARCHAR libre) → `docTipoId` (BIGINT FK a `core.doc_tipo`)
- Response devuelve `docTipoCodigo` y `docTipoNombre` desnormalizados
- `PRD-DT-003` actualizado a "tipo de documento (doc_tipo) inexistente"

### 3.2 `3d0a8ca1` — Expansión completa del contrato

**Archivos:**
- `05. Documentacion/markdown/Contratos/ms-produccion/CONTRATO_ARTICULO_DOC_TECNICA.md`
- `05. Documentacion/markdown/Contratos/ms-produccion/HU_ARTICULO_DOC_TECNICA.md`

**Endpoints nuevos:**
- `PATCH /api/produccion/documentacion-tecnica/{id}/activar`
- `PATCH /api/produccion/documentacion-tecnica/{id}/desactivar`
- `DELETE /api/produccion/documentacion-tecnica/{id}`

**Cambios:**
- ~140 → ~450 líneas (contrato) y ~40 → ~120 líneas (HU)
- Nuevos endpoints: `PATCH activar`, `PATCH desactivar`, `DELETE`
- Nuevo campo: `documentoExtension`, `tieneDocumentoBlob: boolean`
- Respuestas de error completas con ejemplos JSON

---

## 4. Labor — 1 modificación

### `3d0a8ca1` — Expansión con ejecutores

**Archivos:**
- `05. Documentacion/markdown/Contratos/ms-produccion/CONTRATO_LABOR.md`
- `05. Documentacion/markdown/Contratos/ms-produccion/HU_LABOR.md`

**Endpoints nuevos en labor:**
- `PATCH /api/produccion/labores/{id}/activar`
- `PATCH /api/produccion/labores/{id}/desactivar`
- `DELETE /api/produccion/labores/{id}`

**Endpoints nuevos en ejecutores (sub-recurso):**
- `GET /api/produccion/labores/{id}/ejecutores` — listar ejecutores asignados
- `POST /api/produccion/labores/{id}/ejecutores` — asignar ejecutor con datos de costeo
- `PUT /api/produccion/labores/{id}/ejecutores/{ejecutorId}` — actualizar costeo
- `DELETE /api/produccion/labores/{id}/ejecutores/{ejecutorId}` — desasignar

**Endpoints nuevos en insumos (sub-recurso):**
- `GET /api/produccion/labores/{id}/insumos`
- `POST /api/produccion/labores/{id}/insumos`
- `DELETE /api/produccion/labores/{id}/insumos/{articuloId}`

**Endpoints nuevos en producidos (sub-recurso):**
- `GET /api/produccion/labores/{id}/producidos`
- `POST /api/produccion/labores/{id}/producidos`
- `DELETE /api/produccion/labores/{id}/producidos/{articuloId}`

**Cambios:**
- Nueva entidad `labor_ejecutor` con sub-endpoints
- Secciones completas de `ApiResponse`, códigos HTTP, convenciones, validación, paginación
- Endpoints agregados: `PATCH activar`, `PATCH desactivar`, `DELETE`
- Alcance ampliado: labor ahora maneja ejecutores + insumos + producidos

---

## 5. Control de Calidad — 2 modificaciones

### 5.1 `35340229` — JSON completos en contrato

**Archivo:**
- `05. Documentacion/markdown/Contratos/ms-produccion/CONTRATO_CONTROL_CALIDAD.md`

**Endpoints afectados (solo response/request, no cambia la ruta):**
- `GET /api/produccion/controles-calidad` — response expandido con objetos anidados
- `GET /api/produccion/controles-calidad/{id}` — idem
- `POST /api/produccion/controles-calidad` — body completo con campos opcionales documentados
- `PUT /api/produccion/controles-calidad/{id}` — idem

**Cambios:**
- ~80 → ~380 líneas
- Se documenta que `ordenTrabajoId` e `inspectorId` son opcionales
- Resultados válidos: `APROBADO`, `RECHAZADO`, `OBSERVADO`
- Responses detallados con ejemplos para cada operación

### 5.2 `3980bfbe` — HU expandida

**Archivo:**
- `05. Documentacion/markdown/Contratos/ms-produccion/HU_CONTROL_CALIDAD.md`

**Endpoints afectados:** Ninguno (solo documentación de HU)

**Cambios:**
- ~25 → ~115 líneas
- Se documenta que `control_calidad` no tiene `flag_estado` (el resultado funciona como estado)
- Una OT puede tener múltiples controles (inspecciones sucesivas)
- Códigos de error actualizados

---

## 6. Costeo Producción — 1 modificación

### `0598abc3` — De CRUD a proceso batch

**Archivos:**
- `05. Documentacion/markdown/Contratos/ms-produccion/CONTRATO_COSTEO_PRODUCCION.md`
- `05. Documentacion/markdown/Contratos/ms-produccion/HU_COSTEO_PRODUCCION.md`

**Endpoints eliminados:**
- ~~`POST /api/produccion/costeos`~~ — crear costeo manual
- ~~`PUT /api/produccion/costeos/{id}`~~ — editar costeo manual
- ~~`POST /api/produccion/costeos/{id}/recalcular`~~ — recalcular uno

**Endpoints nuevos:**
- `POST /api/produccion/costeos/procesar` — ejecuta cálculo batch con `anio` + `mes` (opcional `sucursalId`)
- `GET /api/produccion/costeos/por-periodo?anio=&mes=` — consulta resultados por período

**Endpoints modificados:**
- `GET /api/produccion/costeos` — ahora lista paginada de costeos ya procesados (antes era CRUD list)

**Endpoints que se mantienen:**
- `GET /api/produccion/costeos/{id}` — consulta detalle (sin cambios)

**Cambios:**
- **Eliminados** endpoints POST/PUT individuales y `POST /{id}/recalcular`
- **Nuevo** `POST /costeos/procesar` con `anio` + `mes` + opcional `sucursalId`
- **Nuevo** `GET /costeos/por-periodo?anio=&mes=`
- Sistema calcula automáticamente desde partes de producción del período
- Códigos de error simplificados: `PRD-CP-001` al `PRD-CP-005`

---

## Resumen

| Archivo | Veces modificado | Commits |
|---------|-----------------|---------|
| `CONTRATO_API_ORDEN_TRABAJO.md` | 2 | `90263d99`, `5ae919ff` |
| `HU_ORDEN_TRABAJO.md` | 1 | `5ae919ff` |
| `CONTRATO_API_RECETA.md` | 1 | `6139a195` |
| `HU_RECETA.md` | 1 | `6139a195` |
| `CONTRATO_ARTICULO_DOC_TECNICA.md` | 2 | `83dc4a41`, `3d0a8ca1` |
| `HU_ARTICULO_DOC_TECNICA.md` | 2 | `83dc4a41`, `3d0a8ca1` |
| `CONTRATO_LABOR.md` | 1 | `3d0a8ca1` |
| `HU_LABOR.md` | 1 | `3d0a8ca1` |
| `CONTRATO_CONTROL_CALIDAD.md` | 1 | `35340229` |
| `HU_CONTROL_CALIDAD.md` | 1 | `3980bfbe` |
| `CONTRATO_COSTEO_PRODUCCION.md` | 1 | `0598abc3` |
| `HU_COSTEO_PRODUCCION.md` | 1 | `0598abc3` |

---

## Archivos Nuevos (solo creados, nunca modificados)

### 1. Parte de Producción

**Archivos:** `CONTRATO_API_PARTE_PRODUCCION.md`, `HU_PARTE_PRODUCCION.md`

**Endpoints:** `GET /api/produccion/partes-produccion`, `GET /{id}` (con insumos + producidos), `POST`, `PUT /{id}`, `PATCH /{id}/activar`, `PATCH /{id}/desactivar`

**Propósito:** Registrar partes diarios vinculados a una OT: insumos consumidos y productos obtenidos. Control de avance y trazabilidad.

**Implementado en Java:** ✅ Sí — `ParteProduccionController`, service, repository, entities.

---

### 2. Programación de Producción

**Archivos:** `CONTRATO_PROGRAMACION_PRODUCCION.md`, `HU_PROGRAMACION_PRODUCCION.md`

**Endpoints:** `GET /api/produccion/programaciones`, `GET /{id}`, `POST`, `PUT /{id}`, `PATCH /{id}/activar`, `PATCH /{id}/desactivar`

**Propósito:** Programar producción recurrente vinculando recetas con OT, sucursales y frecuencias (DIARIA/SEMANAL/MENSUAL).

**Implementado en Java:** ✅ Sí — `ProgramacionProduccionController`, service, repository, entity.

---

### 3. Tipo de Orden de Trabajo (OT Tipo)

**Archivos:** `CONTRATO_OT_TIPO.md`, `HU_OT_TIPO.md`

**Endpoints:** `GET /api/produccion/ot-tipos`, `GET /{id}`, `POST`, `PUT /{id}`, `PATCH /{id}/activar`, `PATCH /{id}/desactivar`, `DELETE /{id}`

**Propósito:** Maestro de clasificación de OTs (codigo + nombre). Baja lógica bloqueada si hay OTs asociadas.

**Implementado en Java:** ✅ Sí — `OtTipoController`, service, repository, entity, tests.

---

### 4. Administración de Orden de Trabajo (OT Admin)

**Archivos:** `CONTRATO_OT_ADMINISTRACION.md`, `HU_OT_ADMINISTRACION.md`

**Endpoints:** CRUD sobre `/api/produccion/ot-administraciones` + sub-recurso `/{id}/usuarios` (GET, POST, DELETE)

**Propósito:** Áreas administrativas de OT con tipo de costo y usuarios responsables (1:N via `ot_admin_uder`).

**Implementado en Java:** ✅ Sí — `OtAdministracionController`, service, repository, entities, tests.

---

### 5. Ejecutor

**Archivos:** `CONTRATO_EJECUTOR.md`, `HU_EJECUTOR.md`

**Endpoints:** `GET /api/produccion/ejecutores`, `GET /{id}`, `POST`, `PUT /{id}`, `PATCH /{id}/activar`, `PATCH /{id}/desactivar`, `DELETE /{id}`

**Propósito:** Maestro de ejecutores de producción (cuadrillas internas o proveedores externos), con referencia opcional a centro de costo contable y flag interno/externo.

**Implementado en Java:** ✅ Sí — `EjecutorController`, service, repository, entity, mapper.

---

### 6. Labor-Ejecutor

**Archivos:** `CONTRATO_LABOR_EJECUTOR.md`, `HU_LABOR_EJECUTOR.md`

**Endpoints:** Sub-recurso dentro de `/api/produccion/labores/{id}/ejecutores/` (GET list, POST, PUT, DELETE), no controller propio.

**Propósito:** Relación N:N entre labores y ejecutores con parámetros de costeo (factor de conversión, nro. personas, ratio, costo unitario, moneda, tipo costo fijo/variable).

**Implementado en Java:** ✅ Sí — Sub-recurso en `LaborController`, entity `LaborEjecutor`, repository, mapper.

---

### Resumen de archivos nuevos

| Par | Implementado? |
|---|---|---|
| Parte de Producción | ✅ Sí |
| Programación de Producción | ✅ Sí |
| OT Tipo | ✅ Sí (con tests) |
| OT Administración | ✅ Sí (con tests) |
| Ejecutor | ✅ Sí |
| Labor-Ejecutor | ✅ Sí (sub-recurso en LaborController) |

---

## 7. Tests Unitarios — 1 modificación

### `1a19567a` — Cobertura: 47% → 92% instrucciones, 35% → 73% branches

**Archivos:** 27 archivos de test (`src/test/java/pe/restaurant/produccion/`)

| Capa | Archivos | Cambio |
|------|----------|--------|
| **Controllers** | 9 nuevos + 1 modificado | Se agregaron tests para todos los controllers. Todos al 100% de cobertura. |
| **Services** | 8 modificados | Tests reescritos con cobertura exhaustiva de branches (validaciones, FeignException, enrich, normalizar). |
| **Mappers** | 2 nuevos | Tests de `toEntity` + `updateEntity` para todos los mappers (antes solo cubrían `toResponse`). Todos al 93-98%. |
| **Config** | 3 nuevos | `FeignConfigTest`, `ProduccionJwtAuthenticationFilterTest`, `TokensSessionVerifierTest`. |

**Cobertura final del módulo:**

| Métrica | Antes | Después |
|---------|-------|---------|
| Tests | ~165 | **517** |
| Instrucciones | 46.9% | **91.6%** |
| Branches | 34.7% | **72.7%** |

**Clases con mayor mejora:**

| Clase | Antes | Después |
|-------|-------|---------|
| `CosteoProduccionServiceImpl` | 7.6% | **94.1%** |
| `RecetaServiceImpl` | 49.6% | **86.9%** |
| `ArticuloDocTecnicaServiceImpl` | 12.9% | **87.3%** |
| `OrdenTrabajoServiceImpl` | 42.7% | **89.1%** |
| `ParteProduccionServiceImpl` | 46.5% | **79.4%** |
| `OperacionServiceImpl` | 46.4% | **79.6%** |
| `OperacionController` | 10.4% | **100%** |
| `DocTecnicaController` | 9.4% | **100%** |
| `ParteProduccionController` | 7.6% | **100%** |
| `RecetaController` | 6.5% | **92.7%** |
| 8 mappers (cada uno) | ~3% | **93-98%** |
