# Reglas de Negocio - ms-produccion

**Leyenda:** ✅ implementado · ⏳ pendiente (integración u otro MS) · — transversal

Fuente: `ProduccionErrorCodes.java` y HUs en `05. Documentacion/markdown/Contratos/ms-produccion/`.

> El prefijo `PRD-OT-*` en **Tipo OT** (catálogo) y **Orden de Trabajo** comparten numeración; el endpoint define el significado.

## Códigos por dominio

| Prefijo | Entidad |
|---|---|
| `PRD-OT-*` | Tipo OT y Orden de Trabajo |
| `PRD-OA-*` | Administración OT |
| `PRD-LB-*` | Labor |
| `PRD-EJ-*` | Ejecutor |
| `PRD-RC-*` | Receta |
| `PRD-DT-*` | Documentación técnica |
| `PRD-OP-*` | Operación |
| `PRD-PP-*` | Programación |
| `PRD-PT-*` | Parte producción |
| `PRD-CC-*` | Control calidad |
| `PRD-CP-*` | Costeo |

## Reglas transversales

| Regla | Código | Estado | Notas |
|---|---|---|---|
| Baja lógica | — | ✅ | `flagEstado = "0"` salvo pivotes |
| Código único por tenant | — | ✅ | Mayúsculas, sin espacios |
| Borrado físico | — | ✅ | `ot_admin_uder`, `labor_insumo`, `labor_produccion` |
| Validación externa | — | ✅ | Feign y/o SQL nativo a `auth`/`core`/`contabilidad`/`almacen`/`compras` |

---

## Reglas por dominio

### Ejecutor (`PRD-EJ`)

| Regla | Código | Estado |
|---|---|---|
| Datos incompletos | `PRD-EJ-001` | ✅ |
| Centro de costo inexistente | `PRD-EJ-002` | ✅ |
| Código duplicado | `PRD-EJ-003` | ✅ |
| Referencias en `labor_ejecutor` | `PRD-EJ-004` | ✅ |

### Orden de trabajo (`PRD-OT`)

| Regla | Código | Estado | Notas |
|---|---|---|---|
| Sucursal inexistente | `PRD-OT-001` | ✅ | |
| Tipo OT inexistente | `PRD-OT-002` | ✅ | |
| Admin OT inexistente | `PRD-OT-003` | ✅ | |
| Código OT duplicado | `PRD-OT-004` | ✅ | |
| Fecha inicio requerida | `PRD-OT-005` | ✅ | |
| Fecha fin &lt; inicio | `PRD-OT-006` | ✅ | |
| Nro operación duplicado en OT | `PRD-OT-007` | ✅ | En operaciones |
| Labor inexistente | `PRD-OT-008` | ✅ | |
| Ejecutor inexistente | `PRD-OT-009` | ✅ | |
| Entidad contribuyente inexistente | `PRD-OT-010` | ✅ | |
| Centro de costo inexistente | `PRD-OT-011` | ✅ | |
| UM inexistente | `PRD-OT-012` | ✅ | |
| Artículo inexistente | `PRD-OT-013` | ✅ | |
| Cantidad requerida ≤ 0 | `PRD-OT-014` | ✅ | |
| Sin operaciones al cerrar | `PRD-OT-015` | ✅ | `POST .../cerrar` |
| Cantidad/costo negativo | `PRD-OT-016` | ✅ | |
| Conflicto de estado | `PRD-OT-CONFLICT` | ✅ | PUT/cerrar/anular |
| Anular con vales | `PRD-OT-ANULAR-VALE` | ✅ | SQL `almacen.vale_mov` |
| Anular con OC/OS | `PRD-OT-ANULAR-OC` | ✅ | SQL `compras.*` |
| Cerrar OT | — | ✅ | Evento `produccion.completada` |
| Anular OT | — | ✅ | Evento `produccion.cancelada` |

### Operación (`PRD-OP`)

| Regla | Código | Estado |
|---|---|---|
| Labor inexistente | `PRD-OP-001` | ✅ |

### Costeo (`PRD-CP`)

| Regla | Código | Estado | Notas |
|---|---|---|---|
| Período obligatorio | `PRD-CP-001` | ✅ | |
| Período inválido | `PRD-CP-002` | ✅ | |
| Sin OTs en período | `PRD-CP-003` | ✅ | |
| Sucursal inexistente | `PRD-CP-004` | ✅ | |
| Error cálculo | `PRD-CP-005` | ⏳ | Rendimiento 0 → `costo_unitario = 0` |
| Batch `POST /procesar` | — | ✅ | Eventos `costeo.completado` / `costeada` |
| Idempotencia | — | ✅ | UK `(orden_trabajo_id, anio, mes)` |

### Control calidad (`PRD-CC`)

| Regla | Código | Estado |
|---|---|---|
| Datos incompletos | `PRD-CC-001` | ✅ |
| OT/inspector inexistente | `PRD-CC-002` | ✅ |
| Resultado inválido | `PRD-CC-003` | ✅ | APROBADO, RECHAZADO, OBSERVADO |
| No encontrado | `PRD-CC-004` | ✅ |

Rutas: `/controles-calidad` y `/control-calidad`.

---

## Flujo de estado OT

| flag_estado | Significado |
|:---:|---|
| `1` | Activa |
| `2` | Cerrada |
| `0` | Anulada |

- Activa → Cerrada: requiere ≥1 operación activa.
- Activa → Anulada: sin vales ni OC/OS vinculadas.
- Cerrada/Anulada: no admite `PUT` (`PRD-OT-CONFLICT`).

## Costeo batch

1. `anio` + `mes` (+ `sucursalId` opcional).
2. OTs con partes en el período.
3. `costo_materia_prima` = Σ consumos del período; MO/indirecto desde receta/programación.
4. `costo_unitario` = total / rendimiento (0 si sin producción).
5. Re-ejecutar actualiza por UK período.

## Pendiente (otros MS / fuera de API)

| Ítem | Estado |
|---|---|
| Generar vale automático al registrar parte | ⏳ ms-almacén |
| Consumidores Rabbit en contabilidad/auditoría | ⏳ |
| UI frontend | ⏳ |
| Migraciones DDL catálogos (`10_AUDITORIA_DDL.md`) | ⏳ |
