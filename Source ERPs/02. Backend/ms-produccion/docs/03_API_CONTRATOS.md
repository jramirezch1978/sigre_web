# Contratos API - ms-produccion

## Convenciones Generales

- **Base path**: `/api/produccion`
- **Response wrapper**: `ApiResponse<T>` (del módulo common)
- **Autenticación**: JWT (Bearer token) en header `Authorization`, excepto swagger/actuator
- **Paginación**: Parámetros `page`, `size`, `sort` estándar de Spring (ej: `?page=0&size=20&sort=id,asc`)
- **Formato fechas**: `dd/MM/yyyy HH:mm:ss`
- **Códigos de error**: Prefijo `PRD-` por dominio (ver documento de reglas de negocio)

---

## API Implementadas (Capa 1 - CRUD Maestros)

### 1. OT Tipos — `/api/produccion/ot-tipos`

| Método | Ruta | Descripción | Params/Body |
|---|---|---|---|
| GET | `/` | Listar (paginado + filtros) | `codigo`, `nombre`, `flagEstado` (query) |
| GET | `/{id}` | Obtener por ID | — |
| POST | `/` | Crear | `@Valid OtTipoRequest` |
| PUT | `/{id}` | Actualizar | `@Valid OtTipoRequest` |
| PATCH | `/{id}/activar` | Activar (flagEstado = "1") | — |
| PATCH | `/{id}/desactivar` | Desactivar (flagEstado = "0") | — |
| DELETE | `/{id}` | Baja lógica | — |

**OtTipoRequest:**
```json
{
  "codigo": "PRODUCCION",
  "nombre": "Producción"
}
```

**OtTipoResponse:**
```json
{
  "id": 1,
  "codigo": "PRODUCCION",
  "nombre": "Producción",
  "flagEstado": "1",
  "createdBy": "admin",
  "fecCreacion": "25/05/2026 10:00:00",
  "updatedBy": null,
  "fecModificacion": null
}
```

---

### 2. OT Administraciones — `/api/produccion/ot-administraciones`

| Método | Ruta | Descripción | Params/Body |
|---|---|---|---|
| GET | `/` | Listar (paginado + filtros) | `codigo`, `nombre`, `tipoCosto`, `flagEstado` |
| GET | `/{id}` | Obtener por ID | — |
| POST | `/` | Crear | `@Valid OtAdministracionRequest` |
| PUT | `/{id}` | Actualizar | `@Valid OtAdministracionRequest` |
| PATCH | `/{id}/activar` | Activar | — |
| PATCH | `/{id}/desactivar` | Desactivar | — |
| DELETE | `/{id}` | Baja lógica | — |
| GET | `/{id}/usuarios` | Listar usuarios asignados | — |
| POST | `/{id}/usuarios` | Asignar usuario | `{ "usuarioId": 5 }` |
| DELETE | `/{id}/usuarios/{usuarioId}` | Desasignar usuario | — |

**OtAdministracionRequest:**
```json
{
  "codigo": "COCINA_CENTRAL",
  "nombre": "Cocina Central",
  "tipoCosto": "MO"
}
```

---

### 3. Labores — `/api/produccion/labores`

| Método | Ruta | Descripción | Params/Body |
|---|---|---|---|
| GET | `/` | Listar (paginado + filtros) | `codigo`, `nombre`, `flagEstado` |
| GET | `/{id}` | Obtener por ID | — |
| POST | `/` | Crear | `@Valid LaborRequest` |
| PUT | `/{id}` | Actualizar | `@Valid LaborRequest` |
| PATCH | `/{id}/activar` | Activar | — |
| PATCH | `/{id}/desactivar` | Desactivar | — |
| DELETE | `/{id}` | Baja lógica | — |
| GET | `/{id}/insumos` | Listar insumos | — |
| POST | `/{id}/insumos` | Asignar insumo | `{ "articuloId": 10 }` |
| DELETE | `/{id}/insumos/{articuloId}` | Desasignar insumo | — |
| GET | `/{id}/producidos` | Listar producidos | — |
| POST | `/{id}/producidos` | Asignar producido | `{ "articuloId": 20 }` |
| DELETE | `/{id}/producidos/{articuloId}` | Desasignar producido | — |

**LaborRequest:**
```json
{
  "codigo": "CORTE_VEGETALES",
  "nombre": "Corte de Vegetales"
}
```

---

## API Implementadas (Capa 2 - Núcleo de Producción)

### 4. Recetas — `/api/produccion/recetas`

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/` | Listar (paginado + filtros: `codigo`, `nombre`, `tipo`, `flagEstado`, `articuloProducidoId`) |
| GET | `/{id}` | Obtener por ID (incluye labores, consumibles y ficha técnica) |
| POST | `/` | Crear (cabecera + labores + consumibles + ficha técnica) |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/activar` | Activar |
| PATCH | `/{id}/desactivar` | Desactivar |
| POST | `/{id}/nueva-version` | Crear nueva versión |
| DELETE | `/{id}` | Baja lógica |

### 5. Órdenes de Trabajo — `/api/produccion/ordenes-trabajo`

| Método | Ruta | Descripción | Contrato |
|---|---|---|---|
| GET | `/` | Listar (filtros: `codigo`, `sucursalId`, `otTipoId`, `otAdministracionId`, `fechaInicio`, `fechaFin`, `flagEstado`) | ✅ |
| GET | `/{id}` | Obtener por ID (con operaciones + detalles) | ✅ |
| POST | `/` | Crear (cabecera + operaciones + detalles) | ✅ |
| PUT | `/{id}` | Actualizar | ✅ |
| PATCH | `/{id}/activar` | Activar (flagEstado = "1") | ✅ |
| PATCH | `/{id}/desactivar` | Desactivar (flagEstado = "0") | ✅ |
| POST | `/{id}/cerrar` | Cerrar OT (flagEstado = "2") | ✅ |
| POST | `/{id}/anular` | Anular OT (flagEstado = "0") | ✅ |
| DELETE | `/{id}` | Baja lógica | ⚠️ No existe en contrato |
| POST | `/{id}/cerrar` | Cierra OT (estado 2); valida operaciones activas; evento `produccion.completada` | ✅ |
| POST | `/{id}/anular` | Anula OT (estado 0); valida vales/OC; evento `produccion.cancelada` | ✅ |

### 6. Operaciones — `/api/produccion/operaciones`

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/` | Listar (filtros: `ordenTrabajoId`, fechas, `flagEstado`) |
| GET | `/{id}` | Detalle con enrich (OT, labor, ejecutor, artículos) |
| POST | `/` | Crear operación (cabecera: `nroOperacion`, `laborId`, `ejecutorId`, fechas, costos…) |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/activar` | Activar |
| PATCH | `/{id}/desactivar` | Desactivar |
| DELETE | `/{id}` | Baja lógica |
| GET | `/{id}/detalles` | Listar detalle (artículo + cantidad) |
| POST | `/{id}/detalles` | Agregar línea de material |

### 7. Ejecutor — `/api/produccion/ejecutores`

| Método | Ruta | Descripción |
|---|---|---|
| GET/POST/PUT/PATCH activar/desactivar/DELETE | CRUD maestro ejecutor (interno/externo, centro de costo) | ✅ |

Sub-recurso **Labor-Ejecutor:** `GET/POST/PUT/DELETE /labores/{id}/ejecutores`

### 8. Programación de Producción — `/api/produccion/programaciones`

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/` | Listar (filtros: `recetaId`, `sucursalId`, `frecuencia`, `fechaInicio`, `fechaFin`, `flagEstado`) |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/activar` | Activar |
| PATCH | `/{id}/desactivar` | Desactivar |
| DELETE | `/{id}` | Baja lógica |

### 9. Partes de Producción — `/api/produccion/partes-produccion`

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/` | Listar |
| GET | `/{id}` | Obtener por ID (incluye insumos y producidos) |
| POST | `/` | Crear (insumos consumidos + productos obtenidos) |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/activar` | Activar |
| PATCH | `/{id}/desactivar` | Desactivar |
| DELETE | `/{id}` | Baja lógica |
| GET | `/{id}/insumos` | Sub-recurso insumos |
| GET | `/{id}/producidos` | Sub-recurso producidos |

### 10. Control de Calidad — `/api/produccion/controles-calidad` (alias `/control-calidad`)

| Método | Ruta | Descripción | Contrato |
|---|---|---|---|
| GET | `/` | Listar (filtros: `ordenTrabajoId`, `resultado`, `fechaDesde`, `fechaHasta`, `inspectorId`) | ✅ |
| GET | `/{id}` | Obtener por ID | ✅ |
| POST | `/` | Registrar control (inspector, fecha, resultado, observaciones) | ✅ |
| PUT | `/{id}` | Actualizar | ✅ |
| DELETE | `/{id}` | Eliminar | ✅ |

### 11. Costeo de Producción — `/api/produccion/costeos` (alias `/costeo-produccion`)

> Proceso **batch** mensual (contrato: sin CRUD manual de valores). Servicio interno `guardar()` para upsert.

| Método | Ruta | Descripción | Estado |
|---|---|---|---|
| POST | `/procesar` | Batch por `anio` + `mes` (+ `sucursalId`); publica eventos RabbitMQ | ✅ |
| GET | `/` | Listar (filtros `ordenTrabajoId`, `anio`, `mes`) | ✅ |
| GET | `/{id}` | Detalle | ✅ |
| GET | `/por-periodo` | Listado por período | ✅ |

### 12. Documentación Técnica — `/api/produccion/documentacion-tecnica`

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/` | Listar |
| GET | `/{id}` | Obtener por ID (incluye características) |
| POST | `/` | Crear (incluye características detalladas) |
| PUT | `/{id}` | Actualizar |
| PATCH | `/{id}/activar` | Activar |
| PATCH | `/{id}/desactivar` | Desactivar |
| DELETE | `/{id}` | Baja lógica |
| GET | `/{id}/caracteristicas` | Sub-recurso características |

---

## Resumen de Implementación

| API | Implementado | vs Contrato |
|---|---|---|
| OT Tipos | ✅ | ✅ Coincide |
| OT Administraciones | ✅ | ✅ Coincide |
| Labores | ✅ | ✅ Coincide |
| Recetas | ✅ | ✅ Coincide |
| Órdenes de Trabajo | ✅ | ✅ Coincide |
| Programación Producción | ✅ | ✅ Coincide |
| Partes de Producción | ✅ | ✅ Coincide |
| Control de Calidad | ✅ | ✅ Coincide |
| Costeo Producción | ✅ | ✅ Coincide (batch) |
| Documentación Técnica | ✅ | ⚠️ PRD-DT-003 pendiente |
