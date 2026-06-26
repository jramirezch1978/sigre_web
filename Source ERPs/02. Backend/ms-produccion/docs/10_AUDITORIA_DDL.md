# Auditoría DDL vs Contratos — ms-produccion

> DDL: `03. Base de datos/ddl/tenant/09-produccion.sql`
> Contratos: `05. Documentacion/markdown/Contratos/ms-produccion/`

---

## 1. Diagrama de relaciones VS DDL real

El encabezado del DDL tiene un diagrama comentado que NO coincide con las tablas reales:

| Línea | Diagrama dice | DDL real tiene | ¿Correcto? |
|-------|---------------|----------------|:----------:|
| 15 | `receta_labor_consumible → receta_labor` | `receta_padre_id → receta(id)` | ❌ Apunta a `receta`, no a `receta_labor` |
| 15 | `receta_labor_consumible → core.unidad_medida` | No existe `unidad_medida_id` en la tabla | ❌ |
| 18 | `operaciones_det → labor` | No hay `labor_id` en `operaciones_det` | ❌ Solo tiene `articulo_id` |
| 18 | `operaciones_det → core.unidad_medida` | No hay `unidad_medida_id` | ❌ |
| 20 | `programacion_produccion → receta_labor` | `receta_id → receta(id)` | ❌ Apunta a `receta`, no a `receta_labor` |

---

## 2. Campos estado/tipo con valores string descriptivos

Regla: **todo campo que refleje un estado debe usar valor numérico almacenado como texto o número** (`'0'`,`'1'`,`'2'`...).  
Los campos tipo/catálogo deben ser FK o `flag_`+CHECK.

### ❌ Violan la regla (string descriptivo en vez de código numérico)

| # | Tabla | Campo | Tipo actual | Valor actual | Debería ser |
|---|-------|-------|-------------|--------------|-------------|
| 1 | `control_calidad` | `resultado` | `VARCHAR(20)` | `'APROBADO'`, `'RECHAZADO'`, `'OBSERVADO'` | Código numérico como texto: `'0'`,`'1'`,`'2'` + tabla `core.resultado_calidad` con la descripción |

### ⚠️ Catálogos tipo (deberían ser FK, no string libre)

| # | Tabla | Campo | Tipo actual | Ejemplos de valores | Debería ser |
|---|-------|-------|-------------|--------------------|-------------|
| 2 | `ficha_tecnica` | `tipo_dieta` | `VARCHAR(30)` | `'REGULAR'`, `'VEGETARIANA'` | FK a `core.tipo_dieta` |
| 3 | `ficha_tecnica` | `temperatura_servicio` | `VARCHAR(20)` | `'CALIENTE'`, `'FRIO'` | FK a `core.temperatura_servicio` |
| 4 | `programacion_produccion` | `frecuencia` | `VARCHAR(20)` | `'DIARIA'`, `'SEMANAL'`, `'MENSUAL'` | FK a `core.frecuencia` |
| 5 | `programacion_produccion` | `turno` | `VARCHAR(20)` | `'MANANA'`, `'TARDE'`, `'NOCHE'` | FK a `core.turno` |
| 6 | `ot_administracion` | `tipo_costo` | `VARCHAR(10)` | `'DIRECTO'`, `'INDIRECTO'` | FK a `core.tipo_costo` |

### ✅ Correctos (siguen la convención)

| Tabla | Campo | Patrón |
|-------|-------|--------|
| `receta` | `flag_tipo_receta` | `flag_` + CHECK ✅ |
| `receta` | `flag_estado` | Numérico como texto `'0'`/`'1'` ✅ |
| `labor` | `flag_estado` | ✅ |
| `ejecutor` | `flag_externo` | `flag_` + CHECK (`'0'`/`'1'`) ✅ |
| `labor_ejecutor` | `flag_costo_fijo` | `flag_` + CHECK (`'0'`/`'1'`) ✅ |
| `orden_trabajo` | `flag_estado` | ⚠️ Numérico como texto (`'0'`,`'1'`,`'2'`) PERO `flag_` implica binario. Pendiente de corrección → `estado_ot_id` FK |

---

## 3. Otras diferencias DDL vs Contratos

### `receta_labor_consumible` — falta `unidad_medida_id`

El contrato (`CONTRATO_API_RECETA.md`) no muestra `unidadMedidaId` en consumibles. Tampoco el DDL.  
Pero el diagrama del DDL (línea 15) lo menciona. **El diagrama está desactualizado — el DDL real es correcto.**

### `programacion_produccion.turno` vs `parte_produccion.turno_id`

| Tabla | Campo | Tipo | ¿FK? |
|-------|-------|------|:----:|
| `programacion_produccion` | `turno` | `VARCHAR(20)` | ❌ Libre |
| `parte_produccion` | `turno_id` | `BIGINT` | ⚠️ Sin constraint FK en este archivo |

Inconsistencia: una tabla usa string libre, la otra usa FK (sin constraint). Deberían unificarse.

### Migración legacy (líneas 447-450)

```sql
ALTER TABLE produccion.receta DROP COLUMN IF EXISTS estado;
ALTER TABLE produccion.receta ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
```

Confirma que antes existía un campo `estado` (string descriptivo) y se migró a `flag_estado` numérico.  
**Misma migración debería aplicarse a los 6 campos listados en la sección 2.**

---

## 4. Resumen de acciones

| Prioridad | Acción | Cantidad |
|-----------|--------|:--------:|
| 🔴 Alta | Migrar `control_calidad.resultado` a código numérico + FK | 1 campo |
| 🟡 Media | Migrar `ot_administracion.tipo_costo` a FK | 1 campo |
| 🟡 Media | Migrar `ficha_tecnica.tipo_dieta` a FK | 1 campo |
| 🟡 Media | Migrar `ficha_tecnica.temperatura_servicio` a FK | 1 campo |
| 🟡 Media | Migrar `programacion_produccion.frecuencia` a FK | 1 campo |
| 🟡 Media | Migrar `programacion_produccion.turno` a FK + unificar con `parte_produccion.turno_id` | 1 campo |
| 🟡 Media | Corregir diagrama comentado del DDL (4 líneas incorrectas) | 4 líneas |
| 🔵 Baja | Renombrar `orden_trabajo.flag_estado` → `estado_ot_id` FK (ya es numérico, solo nombre) | 1 campo |
