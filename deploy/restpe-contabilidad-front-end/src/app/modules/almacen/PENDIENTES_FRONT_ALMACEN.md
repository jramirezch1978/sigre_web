# Plan de integración Front — Módulo Almacén

Estado y pendientes del front (`src/app/modules/almacen`) frente al backend `ms-almacen`.
Backend dev: gateway `/api` → `https://panel.dev.contabilidad.restaurant.pe`. Tenant dev (cabeceras `X-Empresa-Id: 2`, `X-Sucursal-Id: 1`) mientras el login no emita el JWT real.

**Leyenda de estado:** ✅ Conectado · 🟡 Parcial / best-effort · 🔴 Gap (falta backend o es de otro MS) · ⛔ Bloqueado por auth (escrituras).

---

## 0. Transversal (afecta a todos los módulos)

**Auth / JWT.** Descripción: el login del front aún autentica contra el monolito legacy; el backend de microservicios espera un JWT de `ms-auth-security`.
- ⛔ Migrar el login para obtener y guardar el JWT definitivo (con `empresaId`/`sucursalId`).
- [ ] Que el interceptor adjunte el `Bearer` real y quitar el hardcode de tenant (`X-Empresa-Id=2` en `almacen-http.service.ts`).
- [ ] Sin esto, todas las **escrituras** (crear/editar/eliminar/confirmar/anular) fallan con `DATABASE_ERROR`.

**Enriquecimiento de nombres.** Descripción: el backend devuelve **ids** (almacén, artículo, proveedor) sin nombres.
- [ ] Resolver nombres (artículo/almacén/unidad/categoría) en el backend o vía catálogos en el front para no mostrar ids pelados.

**Calidad base.**
- [ ] Manejo uniforme de errores/toasts y estados de carga por pantalla.
- [ ] Paginación/filtros reales contra el backend (hoy se trae `size=1000` y se pagina en memoria).

---

## 1. Almacenes (maestro)

Descripción: CRUD de almacenes (lista + ficha).
Estado: ✅ lectura · ⛔ escritura.
- [x] Listar / ver desde `GET /almacenes`.
- [x] Campo **Código** en alta (requerido por backend) + exportar Excel/CSV.
- [ ] Crear/editar/eliminar end-to-end (depende del JWT).
- [ ] Selección real de **tipo de almacén** (hoy se envían nombres, no `almacenTipoId`).

## 2. Catálogos

Descripción: catálogos que alimentan combos (tipos de movimiento, etc.).
Estado: 🟡.
- [x] `tipos_movimiento` ← `GET /tipos-movimiento`.
- [x] Transferencias ← `GET /ordenes-traslado` (best-effort).
- [🔴] Tipos de documento, estados de operación, tipos de despacho, estados de producto, unidades de medida: no existen en `ms-almacen` (son de `ms-core-maestros`). Definir origen.

## 3. Movimientos (vale de movimiento)

Descripción: ingresos/salidas/ajustes de inventario (núcleo del stock).
Estado: 🟡 lectura · ⛔ escritura.
- [x] Listado de movimientos ← `GET /movimientos` (en reporte "mov-almacenes").
- [ ] Pantalla dedicada de movimientos: detalle (`GET /movimientos/{id}`), crear (`POST`), confirmar, anular, devolución.
- [ ] Importar/exportar Excel y PDF del vale (`/movimientos/importar`, `/exportar`, `/pdf`).

## 4. Kardex

Descripción: kardex valorizado por artículo/almacén.
Estado: ✅ (backend nuevo creado).
- [x] Consulta kardex ← `GET /kardex` (filtros almacén/artículo/fechas).
- [ ] Exponer filtros de fecha en la UI y exportación a Excel.

## 5. Consultas

Descripción: consultas de apoyo (artículos, OC, devoluciones, kardex, préstamos).
Estado: 🟡.
- [x] Artículos (stock) ← `GET /stock`.
- [x] Kardex ← `GET /kardex`.
- [🔴] Órdenes de compra y Devoluciones → son de `ms-compras` (integrar contra ese MS).
- [🔴] Préstamos → no modelado en `ms-almacen`.

## 6. Operaciones

Descripción: recepción, despacho, gestión de devoluciones, registro de pérdidas, reposición.
Estado: 🟡 / 🔴.
- [x] Recepciones ← `GET /movimientos?tipoReferenciaOrigen=OC` (best-effort).
- [x] Despachos ← `GET /movimientos?tipoReferenciaOrigen=OV` (best-effort).
- [🔴] Gestión de devoluciones, registro de pérdidas, reposición de stock: sin endpoint dedicado (derivar de movimientos o crear backend).

## 7. Órdenes de traslado

Descripción: traslados entre almacenes (origen → destino) con estados.
Estado: 🟡 lectura · ⛔ escritura.
- [x] Listar ← `GET /ordenes-traslado` (usado en transferencias / req-traslados).
- [ ] Pantalla dedicada: crear, aprobar/rechazar, cerrar, anular, PDF/Excel.

## 8. Tomas de inventario

Descripción: conteos físicos vs sistema y ajustes.
Estado: ✅ lectura · ⛔ escritura.
- [x] Reporte de tomas ← `GET /tomas-inventario`.
- [ ] Crear toma, comparar, cerrar, anular (escrituras).

## 9. Guías de remisión

Descripción: guías y su flujo (creación → tránsito → entrega/anulación).
Estado: 🔴 (no conectado en el front aún).
- [ ] Conectar a `GET/POST /guias-remision` y transiciones de estado.

## 10. Solicitudes de salida

Descripción: documento previo a la salida física.
Estado: 🔴 (no conectado en el front aún).
- [ ] Conectar a `/solicitudes-salida` (CRUD + cambio de estado).

## 11. Lotes / Pallets y Vencimientos

Descripción: lotes por artículo/almacén y control de vencimiento.
Estado: ✅ (vencimientos) · 🔴 (CRUD lotes).
- [x] Historial de vencimiento ← `GET /reportes/lotes-por-vencer` (backend nuevo).
- [ ] CRUD de lotes ← `/lotes-pallets`.

## 12. Reportes

Descripción: reportes de inventario y valorización.
Estado: 🟡.
- [x] Valorización ← `GET /reportes/valorizacion` (backend nuevo).
- [x] Productos de almacén / reposición ← `GET /stock`.
- [x] Recepción de transferencias / req. traslado ← `GET /ordenes-traslado`.
- [🔴] Sin datos en backend: stock mínimo y reposición (no hay umbral mínimo en el modelo), stock por fecha histórico, diagnóstico de almacenes.
- [🔴] De otro MS: productos vendidos (ms-ventas), clasificación y maestro de productos (ms-core-maestros).

## 13. Procesos (batch)

Descripción: recálculo de costo promedio, cuadre de stock, actualización automática.
Estado: 🟡 (contrato distinto).
- [ ] El backend expone estos como **acciones** `POST /procesos/*`; el front los muestra como **listas/resultados**. Adaptar: disparar el proceso y mostrar su `ProcesoAlmacenResponse`.

---

## Resumen rápido

| Módulo | Lectura | Escritura |
|---|---|---|
| Almacenes | ✅ | ⛔ (JWT) |
| Catálogos | 🟡 | — |
| Movimientos | 🟡 | ⛔ |
| Kardex | ✅ | — |
| Consultas | 🟡 | — |
| Operaciones | 🟡 | ⛔ |
| Órdenes traslado | ✅ | ⛔ |
| Tomas inventario | ✅ | ⛔ |
| Guías remisión | 🔴 | 🔴 |
| Solicitudes salida | 🔴 | 🔴 |
| Lotes / Vencimientos | 🟡 | 🔴 |
| Reportes | 🟡 | — |
| Procesos | 🟡 | 🟡 |

**Prioridad sugerida:** (1) desbloquear auth/JWT → habilita todas las escrituras; (2) enriquecer nombres; (3) pantallas dedicadas de Movimientos y Órdenes de traslado; (4) conectar Guías y Solicitudes de salida; (5) crear backend faltante de reportes (stock mínimo, diagnóstico) si se requiere.
