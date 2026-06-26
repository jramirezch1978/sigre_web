# Auditoría: Campos con valores fijos en ms-produccion

> Criterio: si un campo tiene valores fijos (no dependen de otra tabla), debe ser **`flag_*` con CHECK** o **FK a tabla catálogo**.
> Inspiración: `tipo_documento` → `doc_tipo_id` FK a `core.doc_tipo`.
>
> ✅ `flag_tipo_receta` con CHECK (`'P'`,`'B'`,`'G'`,`'S'`,`'D'`,`'E'`,`'I'`) está correcto — usa el patrón `flag_` + CHECK.

---

## Pendientes de corregir

| # | Tabla | Campo | Tipo actual | Valores que debería tener | Problema | Recomendación |
|---|-------|-------|-------------|---------------------------|----------|---------------|
| 1 | `produccion.ficha_tecnica` | `tipo_dieta` | `VARCHAR` libre | "REGULAR", "VEGETARIANA", "VEGANA", "SIN_GLUTEN", "KETO" | Sin CHECK, sin FK, valores libres | Crear `core.tipo_dieta` y FK `ficha_tecnica.tipo_dieta_id` |
| 2 | `produccion.ficha_tecnica` | `temperatura_servicio` | `VARCHAR` libre | "CALIENTE", "FRIO", "TEMPLADO", "AMBIENTE" | Sin CHECK, sin FK, valores libres | Crear `core.temperatura_servicio` y FK `ficha_tecnica.temperatura_servicio_id` |
| 3 | `produccion.ot_administracion` | `tipo_costo` | `VARCHAR(10)` libre | "DIRECTO", "INDIRECTO" | Sin CHECK, sin FK, valores libres | Crear `core.tipo_costo` y FK `ot_administracion.tipo_costo_id` |
| 4 | `produccion.programacion_produccion` | `frecuencia` | `VARCHAR` libre | "DIARIA", "SEMANAL", "QUINCENAL", "MENSUAL", "ANUAL" | Sin CHECK, sin FK, valores libres | Crear `core.frecuencia` y FK `programacion_produccion.frecuencia_id` |
| 5 | `produccion.programacion_produccion` | `turno` | `VARCHAR` libre | "MANANA", "TARDE", "NOCHE" | Sin CHECK, sin FK, valores libres | Crear `core.turno` y FK `programacion_produccion.turno_id` |
| 6 | `produccion.control_calidad` | `resultado` | `VARCHAR(20)` libre | "APROBADO", "RECHAZADO", "OBSERVADO" | Sin CHECK, sin FK, valores libres | Crear `core.resultado_calidad` y FK `control_calidad.resultado_id` |
| 7 | `produccion.orden_trabajo` | `flag_estado` | `VARCHAR(1)` con 3 valores | `'1'`=Activa, `'2'`=Cerrada, `'0'`=Anulada | **No es flag binario** (`flag_*` debe ser `'0'`/`'1'`). Tiene 3 estados. | Renombrar a `estado_ot_id` y FK a `core.estado_ot` |

---

## Correctos (no tocar)

| Tabla | Campo | Patrón | Motivo |
|-------|-------|--------|--------|
| `produccion.receta` | `flag_tipo_receta` | `flag_` + CHECK ✅ | VARCHAR(1) con CHECK, multi-valor pero dentro del patrón flag |
| `produccion.receta` | `flag_estado` | Flag binario ✅ | `'0'`/`'1'` |
| `produccion.labor` | `flag_estado` | Flag binario ✅ | Idem |
| `produccion.labor_ejecutor` | `flag_estado` | Flag binario ✅ | Idem |
| `produccion.labor_ejecutor` | `flag_costo_fijo` | Flag binario ✅ | Idem |
| `produccion.labor_ejecutor` | `moneda_id` | FK ✅ | FK a `core.moneda` |
| `produccion.ot_tipo` | `flag_estado` | Flag binario ✅ | Idem |
| `produccion.ot_administracion` | `flag_estado` | Flag binario ✅ | Idem |
| `produccion.orden_trabajo` / `operacion` / `operaciones_det` | `flag_estado` | Flag binario ✅ | `'0'`/`'1'` (solo la OT cabecera tiene 3 valores) |
| `produccion.programacion_produccion` | `flag_estado` | Flag binario ✅ | Idem |
| `produccion.parte_produccion` | `flag_estado` | Flag binario ✅ | Idem |
| `produccion.articulo_doc_tecnica` | `flag_estado` | Flag binario ✅ | Idem |
| `produccion.articulo_doc_tecnica` | `doc_tipo_id` | FK ✅ | FK a `core.doc_tipo` |

---

## Resumen

**7 campos a corregir** en ms-produccion:
- 6 VARCHAR sin CHECK ni FK → migrar a FK contra tablas catálogo nuevas en `core`
- 1 `flag_estado` de OT con 3 valores → renombrar a `estado_ot_id` + FK a `core.estado_ot`

**Inconsistencia detectada**: `programacion_produccion.turno` es VARCHAR libre, pero `parte_produccion` ya tiene `turno_id` como FK. Deberían usar el mismo mecanismo.
