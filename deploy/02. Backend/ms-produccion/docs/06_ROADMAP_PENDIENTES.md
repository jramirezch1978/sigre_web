# Roadmap y Pendientes - ms-produccion

## Estado General

| Aspecto | Estado | vs Contrato |
|---|---|---|
| Proyecto base (pom.xml, Dockerfile, config) | ✅ Listo | — |
| Maestros básicos (OT Tipo, OT Admin, Labor) | ✅ Implementado | ✅ Coincide |
| Ejecutor (interno/externo, centros costo) | ✅ Implementado | ✅ Coincide |
| Labor-Ejecutor (costos/ratio/personas por ejecutor por labor) | ✅ Implementado | ✅ Coincide |
| API Recetas (receta + labores + consumibles + ficha técnica) | ✅ Implementado + enrich POST/PUT | ✅ Coincide |
| API Órdenes de Trabajo (cod. auto, FK cross-schema) | ✅ Implementado + enrich nested operaciones | ✅ Coincide |
| API Operaciones + detalle | ✅ Implementado (full DDL) | ✅ Coincide |
| API Programación Producción | ✅ Implementado | ✅ Coincide |
| API Partes de Producción (insumos + producidos) | ✅ Implementado | ✅ Coincide |
| API Control de Calidad | ✅ Implementado + enrich OT/inspector | ✅ Coincide |
| API Costeo Producción | ✅ Batch implementado | ✅ Coincide |
| API Documentación Técnica | ✅ Implementado | ✅ Coincide |
| OpenFeign clients | ✅ Implementado (5 clients + FeignConfig) | — |
| Eventos RabbitMQ (productor) | ✅ Implementado | Consumidores en otros MS pendientes |
| Pruebas unitarias (service + controller + mapper) | ⚠️ Parcial | Suite ampliada en develop; ampliar cobertura |
| UI Frontend | ❌ No iniciado | — |

## Flujo Funcional Completo (Estado Objetivo)

```
Receta + Labor + Ficha Técnica
    │
    ▼
Programación Producción (frecuencia DIARIA/SEMANAL/MENSUAL)
    │
    ▼
Orden de Trabajo (Activa → Cerrada → Anulada)
    │
    ▼
Parte de Producción (insumos consumidos + productos obtenidos)
    │
    ▼
Control de Calidad (APROBADO/RECHAZADO/OBSERVADO)
    │
    ▼
Costeo Producción (batch mensual automático)
```

## Prioridad de Implementación

### Fase 0 — Corrección de Gaps vs Contratos (Completada)
1. ✅ **Costeo Producción** — Reimplementado como proceso batch
2. ✅ **OT — Cerrar/Anular** — Endpoints agregados + transiciones de estado
3. ✅ **Control de Calidad** — Path y filtros corregidos
4. ✅ **Doc Técnica — PRD-DT-003** — `tipoDocumento` reemplazado por `doc_tipo_id FK core.doc_tipo`

### Fase 1 — Fundación (Completada)
5. ✅ **Maestros básicos**: OT Tipo, OT Admin, Labor
6. ✅ **Ejecutor + Labor-Ejecutor**: Maestro de ejecutores (interno/externo, centros costo) y asignación de costos/ratio/personas
7. ✅ **Recetas**: CRUD + versionamiento + enrichment + ficha técnica
8. ✅ **Órdenes de Trabajo**: CRUD base + operaciones + detalles

### Fase 2 — Ejecución (Completada)
9. ✅ **Programación Producción**: CRUD + enrichment
10. ✅ **Partes de Producción**: CRUD + insumos + producidos
11. ✅ **Control de Calidad**: Path + filtros corregidos + enrich OT/inspector
12. ✅ **OT — enrich nested operaciones**: GET/{id}, POST, PUT con detalle completo
13. ✅ **Operaciones — enrich**: Código OT, labor, artículo en respuesta
14. ✅ **Recetas — enrich POST/PUT**: Labores, consumibles, ficha técnica poblados

### Fase 3 — Costeo y Cierre
15. ✅ **Costeo Producción**: Reimplementado como proceso batch
16. ✅ **Documentación Técnica**: CRUD + características + doc_tipo_id FK core.doc_tipo

### Fase 4 — Integraciones (Prioridad Media)
17. 🔲 **Consumo automático de almacén** — Generar vales al registrar parte producción
18. 🔲 **Vinculación con compras** — Requerimientos → OCs
19. ✅ **Eventos RabbitMQ (productor)** — Cerrar/anular OT y costeo batch publican en `rpe.events`

### Fase 5 — Infraestructura
20. ✅ **Clientes OpenFeign** — 5 clients + contextId único para evitar conflicto beans
21. ✅ **OT secuencia query** — Bugfix: SUBSTRING → SPLIT_PART + regex
22. 🔲 **Pruebas QA automatizadas** — Incorporar ms-produccion en matriz de pruebas
23. 🔲 **UI Frontend** — Desarrollo de interfaz de usuario

## Próximos Pasos Inmediatos

### ✅ Fase 0 — Corrección de Gaps vs Contratos (Completada)

1. ✅ **Costeo Producción** — Reimplementado como proceso batch (`POST /procesar`, `GET /por-periodo`)
2. ✅ **OT — Cerrar/Anular** — `POST /{id}/cerrar` y `POST /{id}/anular` implementados con PRD-OT-CONFLICT
3. ✅ **Control de Calidad** — Path corregido a `controles-calidad`, filtros agregados, enrich OT/inspector
4. ✅ **Recetas — enrich POST/PUT** — `labores`, `consumibles`, `fichaTecnica` poblados en respuesta
5. ✅ **OT — enrich anidado** — `GET/{id}`, POST, PUT devuelven operaciones con detalles + labor/artículo/UM
6. ✅ **Operaciones — enrich** — Código OT, datos de labor y artículo en respuesta
7. ✅ **Doc Técnica — PRD-DT-003** — `tipoDocumento` reemplazado por `doc_tipo_id FK core.doc_tipo`

### ✅ Fase 1 — Fundación (Completada)

8. ✅ **Ejecutor** — Controller + entity + service + repository implementados
9. ✅ **Labor-Ejecutor** — Sub-recurso `/{id}/ejecutores` en LaborController (GET/POST/PUT/DELETE)
10. ✅ **Operacion entity** — Sincronizada con DDL: nro_operacion, labor_id, ejecutor_id, entidad_contribuyente_id, centros_costo_id, unidad_medida_id, campos planificación y costos
11. ✅ **OperacionesDet** — `labor_id`/`unidad_medida_id` eliminados (solo articulo_id + cantidad_requerida)

### ✅ Fase 5 — OpenFeign (Completada)

12. ✅ **OpenFeign clients** — 5 clients implementados. Agregado `contextId` único para evitar conflicto de beans `ms-core-maestros`.
13. ✅ **OT secuencia query** — Bugfix: native query con `SUBSTRING` parseaba mal → `SPLIT_PART` + regex `~'^OT-[0-9]{4}-[0-9]+$'`

### ✅ Fase 2,3 — Alineación de Contratos (Completada)

14. ✅ **RecetaController** — Endpoint `nueva-version` eliminado
15. ✅ **ControlCalidadResponse** — `ordenTrabajoCodigo` e `inspectorNombre` agregados con enrich
16. ✅ **ProcesarCosteoResponse** — Alineado con contrato: `costoMateriaPrimaTotal`, `costoManoObraTotal`, `costoIndirectoTotal`, `costoGranTotal`
17. ✅ **OrdenTrabajoController** — Filtros renombrados a `fechaInicio`/`fechaFin`
18. ✅ **DELETE extras** — Eliminados de RecetaController, ParteProduccionController, ProgramacionProduccionController

### Pendientes Reales

19. 🔲 **Tests unitarios** — Service tests con mock repos, controller tests con MockMvc, mapper tests
20. 🔲 **Integración con almacén** — Generar vale de movimiento al registrar parte de producción
21. 🔲 **Consumidores RabbitMQ** — `ms-contabilidad` y `ms-auditoria` deben suscribirse
22. 🔲 **UI Frontend** — Desarrollo de interfaz de usuario

## Referencias a la Documentación

Toda la documentación de detalle para cada HU/contrato API está en:
`05. Documentacion/markdown/Contratos/ms-produccion/`

| Archivo | Contenido |
|---|---|
| `HU_RECETA.md` | HU de Recetas |
| `CONTRATO_API_RECETA.md` | Contrato API detallado de Recetas |
| `HU_ORDEN_TRABAJO.md` | HU de Órdenes de Trabajo |
| `CONTRATO_API_ORDEN_TRABAJO.md` | Contrato API detallado (1317 líneas) |
| `HU_PROGRAMACION_PRODUCCION.md` | HU de Programación |
| `CONTRATO_PROGRAMACION_PRODUCCION.md` | Contrato API Programación |
| `HU_PARTE_PRODUCCION.md` | HU de Partes de Producción |
| `CONTRATO_API_PARTE_PRODUCCION.md` | Contrato API Partes |
| `HU_CONTROL_CALIDAD.md` | HU de Control de Calidad |
| `CONTRATO_CONTROL_CALIDAD.md` | Contrato API Control Calidad |
| `HU_COSTEO_PRODUCCION.md` | HU de Costeo |
| `CONTRATO_COSTEO_PRODUCCION.md` | Contrato API Costeo |
| `HU_ARTICULO_DOC_TECNICA.md` | HU de Documentación Técnica |
| `CONTRATO_ARTICULO_DOC_TECNICA.md` | Contrato API Doc Técnica |
| `HU_OT_TIPO.md` | HU de OT Tipo |
| `CONTRATO_OT_TIPO.md` | Contrato API OT Tipo |
| `HU_OT_ADMINISTRACION.md` | HU de OT Administración |
| `CONTRATO_OT_ADMINISTRACION.md` | Contrato API OT Administración |
| `HU_LABOR.md` | HU de Labor |
| `CONTRATO_LABOR.md` | Contrato API Labor (labores + ejecutores + insumos + producidos) |
| `HU_EJECUTOR.md` | HU de Ejecutor (interno/externo) |
| `CONTRATO_EJECUTOR.md` | Contrato API Ejecutor |
| `HU_LABOR_EJECUTOR.md` | HU de Labor-Ejecutor |
| `CONTRATO_LABOR_EJECUTOR.md` | Contrato API Labor-Ejecutor |

## Estructura de Código a Seguir

Al implementar nuevas APIs, mantener el patrón existente:

```
controller/   → REST endpoints (ApiResponse<T>)
dto/          → Request/Response classes
entity/       → JPA entities (extienden AuditOnlyMappedEntity)
mapper/       → MapStruct interfaces (componentModel = "spring")
repository/   → JPA repositories (con JpaSpecificationExecutor si aplica)
service/      → Interface + Impl (con @Timed, @Transactional)
```

Cada nueva entidad debe replicar el patrón de validación:
- `existsBy*` para unicidad case-insensitive
- Validación de referencias externas vía OpenFeign clients
- `@Timed` en servicios
- Baja lógica con `flag_estado` (a menos que sea tabla pivote)

## Notas del DDL Real

Basado en `03. Base de datos/ddl/tenant/09-produccion.sql` (23 tablas en schema `produccion`):

- `created_by` / `updated_by` son `BIGINT` en el DDL, pero `String` en `AuditOnlyMappedEntity` del common — hay que resolver esta discrepancia.
- Tablas **labor complementarias**: `labor_insumo` (artículos que consume una labor), `labor_produccion` (artículos que produce una labor).
- `receta.nro_receta` es `VARCHAR(12) UNIQUE`, no `codigo`; la columna fue renombrada. Tiene `flag_tipo_receta VARCHAR(1)` con CHECK (`P`/`B`/`G`/`S`/`D`/`E`/`I`), `version INTEGER`, y costos estimados.
- `operacion` — entity sincronizada con DDL: incluye `nro_operacion`, `labor_id`, `ejecutor_id`, `entidad_contribuyente_id`, `centros_costo_id`, `unidad_medida_id`, campos de planificación y costos.
- `operaciones_det` — solo `articulo_id` + `cantidad_requerida` (sin `labor_id` ni `unidad_medida_id`).
- `articulo_doc_tecnica.doc_tipo_id` es FK a `core.doc_tipo` (reemplazó `tipo_documento VARCHAR(40)`).
- `costeo_produccion` tiene `anio` y `mes` con UK `(orden_trabajo_id, anio, mes)`.
- `control_calidad.orden_trabajo_id` es NULLABLE; `inspector_id` es BIGINT sin FK explícita.
- `programacion_produccion.sucursal_id` y `orden_trabajo_id` son NULLABLEs.
- `orden_trabajo.codigo` es `VARCHAR(12)`.
- `parte_produccion_insumo.vale_mov_id` es FK a `almacen.vale_mov`.
- Las FK entre módulos se crean en este script (diferido): `almacen.vale_mov → orden_trabajo`, `compras.orden_compra_det → operaciones_det`, `compras.orden_servicio_det → operaciones_det`, `almacen.vale_mov_det → operaciones_det`.

**Lección**: Siempre validar la documentación generada contra el DDL real antes de darla por buena.

## Auditoría Endpoint por Endpoint vs Contratos (27/05/2026)

> Auditoría completa de los 12 controllers (~80 endpoints) contrastados con los contratos actualizados.

### ✅ Controllers OK (coinciden con contrato)

| Controller | Endpoints | Estado |
|-----------|-----------|--------|
| `OtTipoController` | 7 (GET list, GET/{id}, POST, PUT, PATCH activar, PATCH desactivar, DELETE) | ✅ OK |
| `OtAdministracionController` | 10 (7 cabecera + 3 usuarios sub-recurso) | ✅ OK |
| `DocTecnicaController` | 8 (CRUD + activar/desactivar + GET características) | ✅ OK |
| `ParteProduccionController` | 8 (CRUD + activar/desactivar + sub-recursos insumos/producidos) | ✅ OK |
| `RecetaController` | 7 (CRUD + activar/desactivar + labores/consumibles/ficha) | ✅ OK — sin `nueva-version` |
| `OrdenTrabajoController` | 9 (CRUD + activar/desactivar/cerrar/anular) | ✅ OK — filtros `fechaInicio`/`fechaFin` |
| `OperacionController` | 8 (CRUD + activar/desactivar + operaciones-por-ot) | ✅ OK — entity con todos los campos del DDL |
| `ControlCalidadController` | 5 (CRUD + delete) | ✅ OK — enrich OT/inspector implementado |
| `CosteoProduccionController` | 4 (POST procesar, GET list/por-periodo/{id}) | ✅ OK — response alineado con contrato |
| `ProgramacionProduccionController` | 7 (CRUD + activar/desactivar) | ✅ OK |
| `LaborController` | 16 (CRUD + insumos + producidos + ejecutores) | ✅ OK |
| `EjecutorController` | 7 (CRUD + activar/desactivar) | ✅ OK |

### Resumen por Controller

| Controller | Endpoints implementados | vs Contrato | Issues |
|-----------|----------------------|-------------|--------|
| OtTipoController | 7/7 | ✅ | — |
| OtAdministracionController | 10/10 | ✅ | — |
| DocTecnicaController | 8/8 | ✅ | — |
| ParteProduccionController | 8/8 | ✅ | — |
| RecetaController | 7/7 | ✅ | — |
| OrdenTrabajoController | 9/9 | ✅ | — |
| OperacionController | 8/8 | ✅ | — |
| LaborController | 16/16 | ✅ | — |
| ControlCalidadController | 5/5 | ✅ | — |
| CosteoProduccionController | 4/4 | ✅ | — |
| ProgramacionProduccionController | 7/7 | ✅ | — |
| EjecutorController | 7/7 | ✅ | — |

### Pendientes Reales (no son gaps vs contratos)

1. 🔲 **Pruebas unitarias** — Service + controller + mapper tests
2. 🔲 **Integración con almacén (operativa)** — Generar vale de movimiento al registrar parte de producción (salidas e ingresos)
3. ✅ **Integración con almacén (costeo mensual)** — Consumer en ms-almacen para `produccion.costeo.completado` (actualizar vales tipo P del periodo)
4. ✅ **Eventos RabbitMQ (productor ms-produccion)** — Cerrar/anular OT y costeo batch publican en `rpe.events`
5. 🔲 **Consumidores RabbitMQ** — `ms-contabilidad` y `ms-auditoria` deben suscribirse
6. 🔲 **UI Frontend** — Desarrollo de interfaz de usuario
