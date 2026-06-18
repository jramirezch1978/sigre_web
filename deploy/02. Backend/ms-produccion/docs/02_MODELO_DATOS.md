# Modelo de Datos - ms-produccion

> Basado en el DDL real: `03. Base de datos/ddl/tenant/09-produccion.sql`

## Esquema

Todos los objetos de base de datos residen en el esquema `produccion` de PostgreSQL.

**Nota sobre created_by / updated_by**: En el DDL son `BIGINT` (referencia a `auth.usuario`), pero en las entities Java del módulo `common` se modelan como `String`. Hay un desajuste entre la entidad y el DDL.

## Diagrama de Relaciones

```
ot_tipo (sin dependencias)
ot_administracion (sin dependencias)
ot_admin_uder → ot_administracion
orden_trabajo → auth.sucursal, ot_tipo, ot_administracion
labor (sin dependencias)
receta → core.articulo
receta_labor → receta, labor
receta_labor_consumible → receta (padre), receta (hija)
operacion → orden_trabajo
operaciones_det → operacion, labor, core.articulo, core.unidad_medida
programacion_produccion → auth.sucursal, receta, orden_trabajo
parte_produccion → orden_trabajo
parte_produccion_insumo → parte_produccion, core.articulo, core.unidad_medida, almacen.vale_mov
parte_produccion_producido → parte_produccion, core.articulo, core.unidad_medida
articulo_doc_tecnica → core.articulo
articulo_doc_tecnica_caract_det → articulo_doc_tecnica, core.unidad_medida
costeo_produccion → orden_trabajo
control_calidad → orden_trabajo
ficha_tecnica → receta
labor_insumo → labor, core.articulo
labor_produccion → labor, core.articulo
```

## Tablas Implementadas (Todas las tablas del DDL)

> Todas las tablas del esquema `produccion` tienen su entidad JPA y repositorio implementados.

### ot_tipo
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| codigo | VARCHAR(20) | NOT NULL, UNIQUE |
| nombre | VARCHAR(120) | NOT NULL |
| flag_estado | VARCHAR(1) | NOT NULL, DEFAULT '1' |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### ot_administracion
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| codigo | VARCHAR(20) | NOT NULL, UNIQUE |
| nombre | VARCHAR(150) | NOT NULL |
| tipo_costo | VARCHAR(10) | |
| flag_estado | VARCHAR(1) | NOT NULL, DEFAULT '1' |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### ot_admin_uder
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| ot_administracion_id | BIGINT | NOT NULL, FK → produccion.ot_administracion(id) |
| usuario_id | BIGINT | NOT NULL |
| flag_estado | VARCHAR(1) | NOT NULL, DEFAULT '1' |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

Sin UK única en DDL (el código Java valida duplicado).

### labor
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| codigo | VARCHAR(20) | NOT NULL, UNIQUE |
| nombre | VARCHAR(150) | NOT NULL |
| flag_estado | VARCHAR(1) | NOT NULL, DEFAULT '1' |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### labor_insumo
> Sin `flag_estado` — borrado físico (tabla pivote).

| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| labor_id | BIGINT | NOT NULL, FK → produccion.labor(id) |
| articulo_id | BIGINT | NOT NULL, FK → core.articulo(id) |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### labor_produccion
> Sin `flag_estado` — borrado físico (tabla pivote).

| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| labor_id | BIGINT | NOT NULL, FK → produccion.labor(id) |
| articulo_id | BIGINT | NOT NULL, FK → core.articulo(id) |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

## Tablas del Núcleo de Producción

> Entidades Java implementadas.

### receta
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| articulo_producido_id | BIGINT | NOT NULL, FK → core.articulo(id) |
| codigo | VARCHAR(30) | NOT NULL, UNIQUE |
| nombre | VARCHAR(200) | NOT NULL |
| version | INTEGER | NOT NULL, DEFAULT 1 |
| rendimiento_esperado | NUMERIC(18,4) | |
| porcentaje_merma | NUMERIC(8,4) | |
| tipo | VARCHAR(30) | NOT NULL, DEFAULT 'PLATO' |
| flag_estado | VARCHAR(1) | NOT NULL, DEFAULT '1' |
| costo_mano_obra | NUMERIC(18,4) | DEFAULT 0 |
| costo_indirecto | NUMERIC(18,4) | DEFAULT 0 |
| costo_total_estimado | NUMERIC(18,4) | DEFAULT 0 |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### receta_labor
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| receta_id | BIGINT | NOT NULL, FK → produccion.receta(id) |
| labor_id | BIGINT | NOT NULL, FK → produccion.labor(id) |
| secuencia | INTEGER | NOT NULL, DEFAULT 1 |
| descripcion_paso | TEXT | |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### receta_labor_consumible
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| receta_padre_id | BIGINT | NOT NULL, FK → produccion.receta(id) |
| receta_hija_id | BIGINT | NOT NULL, FK → produccion.receta(id) |
| cantidad | NUMERIC(18,4) | NOT NULL, DEFAULT 1 |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### ficha_tecnica
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| receta_id | BIGINT | NOT NULL, FK → produccion.receta(id) |
| alergenos | VARCHAR(200) | |
| calorias | NUMERIC(10,2) | |
| proteinas_g | NUMERIC(10,2) | |
| carbohidratos_g | NUMERIC(10,2) | |
| grasas_g | NUMERIC(10,2) | |
| fibra_g | NUMERIC(10,2) | |
| sodio_mg | NUMERIC(10,2) | |
| tipo_dieta | VARCHAR(30) | |
| foto_presentacion_url | TEXT | |
| instrucciones_emplatado | TEXT | |
| tiempo_preparacion_min | INTEGER | |
| tiempo_coccion_min | INTEGER | |
| temperatura_servicio | VARCHAR(20) | |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### orden_trabajo
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| sucursal_id | BIGINT | NOT NULL, FK → auth.sucursal(id) |
| ot_tipo_id | BIGINT | NOT NULL, FK → produccion.ot_tipo(id) |
| ot_administracion_id | BIGINT | NOT NULL, FK → produccion.ot_administracion(id) |
| codigo | VARCHAR(12) | NOT NULL, UNIQUE |
| fecha_inicio | DATE | NOT NULL |
| fecha_fin | DATE | |
| flag_estado | VARCHAR(1) | NOT NULL, DEFAULT '1' |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### operacion
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| orden_trabajo_id | BIGINT | NOT NULL, FK → produccion.orden_trabajo(id) |
| fecha | DATE | NOT NULL |
| flag_estado | VARCHAR(1) | NOT NULL, DEFAULT '1' |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### operaciones_det
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| operacion_id | BIGINT | NOT NULL, FK → produccion.operacion(id) |
| labor_id | BIGINT | NOT NULL, FK → produccion.labor(id) |
| articulo_id | BIGINT | NOT NULL, FK → core.articulo(id) |
| unidad_medida_id | BIGINT | FK → core.unidad_medida(id) |
| cantidad_requerida | NUMERIC(18,4) | NOT NULL |
| flag_estado | VARCHAR(1) | NOT NULL, DEFAULT '1' |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

FK desde compras: `compras.orden_compra_det.operaciones_det_id` → `produccion.operaciones_det(id)` y `compras.orden_servicio_det.operaciones_det_id` → `produccion.operaciones_det(id)`.

### programacion_produccion
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| sucursal_id | BIGINT | FK → auth.sucursal(id) (NULLABLE) |
| receta_id | BIGINT | NOT NULL, FK → produccion.receta(id) |
| orden_trabajo_id | BIGINT | FK → produccion.orden_trabajo(id) (NULLABLE) |
| frecuencia | VARCHAR(20) | NOT NULL, DEFAULT 'DIARIA' |
| fecha_inicio | DATE | NOT NULL |
| fecha_fin | DATE | |
| cantidad_por_periodo | NUMERIC(18,4) | NOT NULL |
| turno | VARCHAR(20) | |
| flag_estado | VARCHAR(1) | NOT NULL, DEFAULT '1' |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### parte_produccion
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| orden_trabajo_id | BIGINT | NOT NULL, FK → produccion.orden_trabajo(id) |
| fecha | DATE | NOT NULL |
| turno_id | BIGINT | |
| flag_estado | VARCHAR(1) | NOT NULL, DEFAULT '1' |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### parte_produccion_insumo
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| parte_produccion_id | BIGINT | NOT NULL, FK → produccion.parte_produccion(id) |
| articulo_id | BIGINT | NOT NULL, FK → core.articulo(id) |
| unidad_medida_id | BIGINT | FK → core.unidad_medida(id) |
| cantidad_consumida | NUMERIC(18,4) | NOT NULL |
| vale_mov_id | BIGINT | FK → almacen.vale_mov(id) |
| flag_estado | VARCHAR(1) | NOT NULL, DEFAULT '1' |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### parte_produccion_producido
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| parte_produccion_id | BIGINT | NOT NULL, FK → produccion.parte_produccion(id) |
| articulo_id | BIGINT | NOT NULL, FK → core.articulo(id) |
| unidad_medida_id | BIGINT | FK → core.unidad_medida(id) |
| cantidad_producida | NUMERIC(18,4) | NOT NULL |
| flag_estado | VARCHAR(1) | NOT NULL, DEFAULT '1' |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### control_calidad
> `orden_trabajo_id` es NULLABLE. `inspector_id` es BIGINT sin FK explícita.

| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| orden_trabajo_id | BIGINT | FK → produccion.orden_trabajo(id) (NULLABLE) |
| inspector_id | BIGINT | |
| fecha | DATE | NOT NULL |
| resultado | VARCHAR(20) | NOT NULL |
| observaciones | TEXT | |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### costeo_produccion

| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| orden_trabajo_id | BIGINT | FK → produccion.orden_trabajo(id) (NULLABLE) |
| anio | INTEGER | NOT NULL (período de costeo) |
| mes | INTEGER | NOT NULL (1–12) |
| costo_materia_prima | NUMERIC(18,4) | DEFAULT 0 |
| costo_mano_obra | NUMERIC(18,4) | DEFAULT 0 |
| costo_indirecto | NUMERIC(18,4) | DEFAULT 0 |
| costo_total | NUMERIC(18,4) | DEFAULT 0 |
| costo_unitario | NUMERIC(18,4) | DEFAULT 0 |
| rendimiento_real | NUMERIC(18,4) | |
| porcentaje_merma_real | NUMERIC(8,4) | |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### articulo_doc_tecnica
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| articulo_id | BIGINT | NOT NULL, FK → core.articulo(id) |
| tipo_documento | VARCHAR(40) | NOT NULL |
| nombre_documento | VARCHAR(200) | NOT NULL |
| archivo_url | TEXT | |
| observacion | TEXT | |
| flag_estado | VARCHAR(1) | NOT NULL, DEFAULT '1' |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

### articulo_doc_tecnica_caract_det
| Columna | Tipo | Constraints |
|---|---|---|
| id | BIGSERIAL | PK |
| articulo_doc_tecnica_id | BIGINT | NOT NULL, FK → produccion.articulo_doc_tecnica(id) |
| caracteristica | VARCHAR(120) | NOT NULL |
| valor | VARCHAR(220) | NOT NULL |
| unidad_medida_id | BIGINT | FK → core.unidad_medida(id) |
| flag_estado | VARCHAR(1) | NOT NULL, DEFAULT '1' |
| created_by | BIGINT | |
| fec_creacion | TIMESTAMPTZ | DEFAULT NOW() |
| updated_by | BIGINT | |
| fec_modificacion | TIMESTAMPTZ | |

## Índices

```sql
-- receta
IX_RECETA_01 ON produccion.receta (articulo_producido_id)
IX_RECETA_02 ON produccion.receta (tipo, flag_estado)

-- labor_insumo
IX_LABOR_INSUMO_01 ON produccion.labor_insumo (labor_id)
IX_LABOR_INSUMO_02 ON produccion.labor_insumo (articulo_id)

-- labor_produccion
IX_LABOR_PRODUCCION_01 ON produccion.labor_produccion (labor_id)
IX_LABOR_PRODUCCION_02 ON produccion.labor_produccion (articulo_id)

-- ficha_tecnica
IX_FICHA_TECNICA_01 ON produccion.ficha_tecnica (receta_id)

-- orden_trabajo
IX_ORDEN_TRABAJO_01 ON produccion.orden_trabajo (sucursal_id)

-- operacion
IX_OPERACION_01 ON produccion.operacion (orden_trabajo_id, fecha)

-- operaciones_det
IX_OPERACIONES_DET_01 ON produccion.operaciones_det (operacion_id, labor_id)

-- parte_produccion
IX_PARTE_PRODUCCION_01 ON produccion.parte_produccion (orden_trabajo_id, fecha)

-- parte_produccion_insumo
IX_PARTE_PRODUCCION_INSUMO_01 ON produccion.parte_produccion_insumo (parte_produccion_id, articulo_id)

-- costeo_produccion
IX_COSTEO_PRODUCCION_01 ON produccion.costeo_produccion (orden_trabajo_id)

-- control_calidad
IX_CONTROL_CALIDAD_01 ON produccion.control_calidad (orden_trabajo_id, fecha)

-- almacen (FK diferidas)
IX_VALE_MOV_08 ON almacen.vale_mov (orden_trabajo_id)
IX_VALE_MOV_DET_07 ON almacen.vale_mov_det (operaciones_det_id)
```

## Resumen de Tablas

| # | Tabla | Estado | flag_estado | Observación |
|---|---|---|---|---|
| 1 | `ot_tipo` | ✅ Implementado | Sí | |
| 2 | `ot_administracion` | ✅ Implementado | Sí | |
| 3 | `ot_admin_uder` | ✅ Implementado | Sí | Sin UK única en DDL |
| 4 | `labor` | ✅ Implementado | Sí | |
| 5 | `labor_insumo` | ✅ Implementado | No | Borrado físico (pivote) |
| 6 | `labor_produccion` | ✅ Implementado | No | Borrado físico (pivote) |
| 7 | `receta` | ✅ Implementado | Sí | |
| 8 | `receta_labor` | ✅ Implementado | No | Sin flagEstado |
| 9 | `receta_labor_consumible` | ✅ Implementado | No | Sin flagEstado |
| 10 | `ficha_tecnica` | ✅ Implementado | No | Sin flagEstado |
| 11 | `orden_trabajo` | ✅ Implementado | Sí | Cod. auto OT-YYYY-NNNN |
| 12 | `operacion` | ✅ Implementado | Sí | |
| 13 | `operaciones_det` | ✅ Implementado | Sí | |
| 14 | `programacion_produccion` | ✅ Implementado | Sí | |
| 15 | `parte_produccion` | ✅ Implementado | Sí | |
| 16 | `parte_produccion_insumo` | ✅ Implementado | Sí | |
| 17 | `parte_produccion_producido` | ✅ Implementado | Sí | |
| 18 | `control_calidad` | ✅ Implementado | No | Sin flagEstado, orden_trabajo_id NULLABLE |
| 19 | `costeo_produccion` | ✅ Implementado | No | UK `(orden_trabajo_id, anio, mes)` |
| 20 | `articulo_doc_tecnica` | ✅ Implementado | Sí | |
| 21 | `articulo_doc_tecnica_caract_det` | ✅ Implementado | Sí | |
| 22 | `articulo_estructura` | ❌ No existe en DDL | — | Mencionado en documentación pero sin CREATE TABLE |

## Notas sobre Discrepancias DDL vs Entities Java

1. **Tipo de created_by/updated_by**: DDL usa `BIGINT` (FK a usuario), entities Java usan `String`. Habrá que resolver esto al implementar las nuevas entidades.
2. **`articulo_estructura`**: Mencionado en la documentación de arquitectura y diseño de BD pero no tiene CREATE TABLE en el DDL.
3. Las tablas pivote (`labor_insumo`, `labor_produccion`, `receta_labor_consumible`) no tienen `flag_estado` — se borran físicamente.
