# Inventario de APIs — ms-produccion

Base path: `/api/produccion` | Response: `ApiResponse<T>` | Auth: JWT Bearer

---

## Maestros (preexistentes)

### 1. OT Tipos — `/api/produccion/ot-tipos`
| Método | Ruta | Descripción | Estado |
|--------|------|-------------|--------|
| GET | `/` | Listar paginado (filtros: codigo, nombre, flagEstado) | ✅ |
| GET | `/{id}` | Obtener por ID | ✅ |
| POST | `/` | Crear | ✅ |
| PUT | `/{id}` | Actualizar | ✅ |
| PATCH | `/{id}/activar` | Activar | ✅ |
| PATCH | `/{id}/desactivar` | Desactivar | ✅ |
| DELETE | `/{id}` | Baja lógica | ✅ |

### 2. OT Administraciones — `/api/produccion/ot-administraciones`
| Método | Ruta | Descripción | Estado |
|--------|------|-------------|--------|
| GET | `/` | Listar paginado (filtros: codigo, nombre, tipoCosto, flagEstado) | ✅ |
| GET | `/{id}` | Obtener por ID | ✅ |
| POST | `/` | Crear | ✅ |
| PUT | `/{id}` | Actualizar | ✅ |
| PATCH | `/{id}/activar` | Activar | ✅ |
| PATCH | `/{id}/desactivar` | Desactivar | ✅ |
| DELETE | `/{id}` | Baja lógica | ✅ |
| GET | `/{id}/usuarios` | Listar usuarios asignados | ✅ |
| POST | `/{id}/usuarios` | Asignar usuario | ✅ |
| DELETE | `/{id}/usuarios/{usuarioId}` | Desasignar usuario | ✅ |

### 3. Labores — `/api/produccion/labores`
| Método | Ruta | Descripción | Estado |
|--------|------|-------------|--------|
| GET | `/` | Listar paginado (filtros: codigo, nombre, flagEstado) | ✅ |
| GET | `/{id}` | Obtener por ID | ✅ |
| POST | `/` | Crear | ✅ |
| PUT | `/{id}` | Actualizar | ✅ |
| PATCH | `/{id}/activar` | Activar | ✅ |
| PATCH | `/{id}/desactivar` | Desactivar | ✅ |
| DELETE | `/{id}` | Baja lógica | ✅ |
| GET | `/{id}/insumos` | Listar insumos asignados | ✅ |
| POST | `/{id}/insumos` | Asignar insumo | ✅ |
| DELETE | `/{id}/insumos/{articuloId}` | Desasignar insumo | ✅ |
| GET | `/{id}/producidos` | Listar producidos asignados | ✅ |
| POST | `/{id}/producidos` | Asignar producido | ✅ |
| DELETE | `/{id}/producidos/{articuloId}` | Desasignar producido | ✅ |

---

## Persona A — Planificación (7 entidades, 31 endpoints)

### 4. Recetas — `/api/produccion/recetas`
| Método | Ruta | Descripción | Estado |
|--------|------|-------------|--------|
| GET | `/` | Listar paginado (filtros: codigo, nombre, tipo, flagEstado, articuloProducidoId) | ✅ |
| GET | `/{id}` | Detalle completo (labores + consumibles + ficha técnica) | ✅ |
| POST | `/` | Crear completa (cabecera + detalles) | ✅ |
| PUT | `/{id}` | Actualizar + sync detalles | ✅ |
| PATCH | `/{id}/activar` | Activar | ✅ |
| PATCH | `/{id}/desactivar` | Desactivar | ✅ |
| POST | `/{id}/nueva-version` | Crear nueva versión | ✅ |
| DELETE | `/{id}` | Baja lógica | ✅ |

### 5. Documentación Técnica — `/api/produccion/documentacion-tecnica`
| Método | Ruta | Descripción | Estado |
|--------|------|-------------|--------|
| GET | `/` | Listar paginado (filtros: tipoDocumento, nombreDocumento, flagEstado, articuloId) | ✅ |
| GET | `/{id}` | Detalle con características | ✅ |
| POST | `/` | Crear con características | ✅ |
| PUT | `/{id}` | Actualizar | ✅ |
| PATCH | `/{id}/activar` | Activar | ✅ |
| PATCH | `/{id}/desactivar` | Desactivar | ✅ |
| DELETE | `/{id}` | Baja lógica | ✅ |
| GET | `/{id}/caracteristicas` | Sub-recurso características | ✅ |

### 6. Programación Producción — `/api/produccion/programaciones`
| Método | Ruta | Descripción | Estado |
|--------|------|-------------|--------|
| GET | `/` | Listar paginado (filtros: recetaId, sucursalId, frecuencia, fechaDesde, fechaHasta, flagEstado) | ✅ |
| GET | `/{id}` | Obtener por ID | ✅ |
| POST | `/` | Crear | ✅ |
| PUT | `/{id}` | Actualizar | ✅ |
| PATCH | `/{id}/activar` | Activar | ✅ |
| PATCH | `/{id}/desactivar` | Desactivar | ✅ |
| DELETE | `/{id}` | Baja lógica | ✅ |

---

## Persona B — Ejecución (7 entidades, 33 endpoints) (7 entidades, 33 endpoints)

### 7. Órdenes de Trabajo — `/api/produccion/ordenes-trabajo`
| Método | Ruta | Descripción | Estado |
|--------|------|-------------|--------|
| GET | `/` | Listar paginado (filtros: codigo, sucursalId, otTipoId, fechaDesde, fechaHasta, flagEstado) | ✅ |
| GET | `/{id}` | Obtener por ID | ✅ |
| POST | `/` | Crear (cod. auto OT-YYYY-NNNN) | ✅ |
| PUT | `/{id}` | Actualizar | ✅ |
| PATCH | `/{id}/activar` | Activar | ✅ |
| PATCH | `/{id}/desactivar` | Desactivar | ✅ |
| DELETE | `/{id}` | Baja lógica | ✅ |

### 8. Operaciones — `/api/produccion/operaciones`
| Método | Ruta | Descripción | Estado |
|--------|------|-------------|--------|
| GET | `/` | Listar paginado (filtros: ordenTrabajoId, fecha, flagEstado) | ✅ |
| GET | `/{id}` | Obtener por ID | ✅ |
| POST | `/` | Crear | ✅ |
| PUT | `/{id}` | Actualizar | ✅ |
| PATCH | `/{id}/activar` | Activar | ✅ |
| PATCH | `/{id}/desactivar` | Desactivar | ✅ |
| DELETE | `/{id}` | Baja lógica | ✅ |
| GET | `/{id}/detalles` | Listar detalles de operación | ✅ |
| POST | `/{id}/detalles` | Agregar detalle | ✅ |

### 9. Partes de Producción — `/api/produccion/partes-produccion`
| Método | Ruta | Descripción | Estado |
|--------|------|-------------|--------|
| GET | `/` | Listar paginado | ✅ |
| GET | `/{id}` | Detalle con insumos + producidos | ✅ |
| POST | `/` | Crear con insumos + producidos | ✅ |
| PUT | `/{id}` | Actualizar | ✅ |
| PATCH | `/{id}/activar` | Activar | ✅ |
| PATCH | `/{id}/desactivar` | Desactivar | ✅ |
| DELETE | `/{id}` | Baja lógica | ✅ |
| GET | `/{id}/insumos` | Sub-recurso insumos | ✅ |
| GET | `/{id}/producidos` | Sub-recurso producidos | ✅ |

### 10. Control de Calidad — `/api/produccion/control-calidad`
| Método | Ruta | Descripción | Estado |
|--------|------|-------------|--------|
| GET | `/` | Listar paginado (filtro: ordenTrabajoId) | ✅ |
| GET | `/{id}` | Obtener por ID | ✅ |
| POST | `/` | Registrar control | ✅ |
| PUT | `/{id}` | Actualizar | ✅ |
| DELETE | `/{id}` | Eliminar | ✅ |

### 11. Costeo Producción — `/api/produccion/costeo-produccion`
| Método | Ruta | Descripción | Estado |
|--------|------|-------------|--------|
| GET | `/` | Listar paginado (filtro: ordenTrabajoId) | ✅ |
| GET | `/{id}` | Obtener por ID | ✅ |
| POST | `/` | Crear | ✅ |
| PUT | `/{id}` | Actualizar | ✅ |
| DELETE | `/{id}` | Eliminar | ✅ |
| `(futuro)` | `/procesar` | Procesar costeo batch mensual | ❌ Pendiente |
| `(futuro)` | `/por-periodo` | Costeo por período | ❌ Pendiente |

---

## Resumen

| # | API | Entidades | Endpoints | Responsable |
|---|-----|-----------|-----------|-------------|
| 1 | OT Tipos | 1 | 7 | Preexistente |
| 2 | OT Administraciones | 2 | 10 | Preexistente |
| 3 | Labores | 3 | 13 | Preexistente |
| 4 | **Recetas** | **4** | **8** | **Persona A** |
| 5 | **Doc. Técnica** | **2** | **8** | **Persona A** |
| 6 | **Programación Prod.** | **1** | **7** | **Persona A** |
| 7 | Órdenes Trabajo | 1 | 7 | Persona B |
| 8 | Operaciones | 2 | 9 | Persona B |
| 9 | Partes Producción | 3 | 9 | Persona B |
| 10 | Control Calidad | 1 | 5 | Persona B |
| 11 | Costeo Producción | 1 | 5 (+2) | Persona B |
| | **Total** | **21 entidades** | **88 endpoints** | |
