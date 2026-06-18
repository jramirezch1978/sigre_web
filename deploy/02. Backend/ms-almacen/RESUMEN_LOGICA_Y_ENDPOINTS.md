# `ms-almacen` — resumen de lógica y endpoints

**Orquestación (secuencias por procedimiento + token):** [`05. Documentacion/orquestacion/ORQUESTACION_MS-ALMACEN.md`](../../05.%20Documentacion/orquestacion/ORQUESTACION_MS-ALMACEN.md)

Este documento resume **qué hace** el microservicio `ms-almacen` y **qué endpoints expone**, agrupados por módulos. Está pensado como guía rápida para entender flujos y responsabilidades (no reemplaza los contratos detallados en `05. Documentacion/markdown/Contratos/ms-almacen/`). La normativa de **payloads JSON** (FK con datos descriptivos, fila completa con auditoría y usuario asociado a `created_by`/`updated_by`, `POST`/`PUT` con cuerpo explícito) está en **`CONTRATO_API_MOVIMIENTOS_ALMACEN.md` §2.4** dentro de esa carpeta.

## 1) Responsabilidad del microservicio (visión general)

`ms-almacen` gestiona el **ciclo de movimientos de almacén** (ingresos/salidas/ajustes) y sus artefactos asociados:

- **Maestros de almacén**: tipos de almacén, almacenes, ubicaciones, motivos de traslado, catálogos de tipos de movimiento.
- **Operación**: movimientos (vale de movimiento), órdenes de traslado, guías de remisión, toma de inventario.
- **Integración**: endpoints que reciben eventos/comandos desde otros MS (OC/OV/traslados) y los traducen a **movimientos**.
- **Procesos batch**: rutinas de recálculo/regularización ejecutables por menú/operación.

Patrón de implementación típico:

- **Controller**: valida request, delega al **Service**, arma respuesta `ApiResponse`.
- **Service**: reglas de negocio + transacciones; valida FKs consultando tablas de otros esquemas (`auth.*`, `core.*`) cuando aplica.
- **Repository/Mapper/DTO**: persistencia y mapeo.

## 2) Módulos y endpoints (por controlador)

> Prefijo común: `/api/almacen`

### A. Maestros / configuración

#### Tipos de almacén (`AlmacenTipoController`)
- `GET /almacen-tipos`: lista paginada.
- `GET /almacen-tipos/{id}`: detalle.
- `POST /almacen-tipos`: crear.
- `PUT /almacen-tipos/{id}`: actualizar.
- `PATCH /almacen-tipos/{id}/activar`: activar.
- `PATCH /almacen-tipos/{id}/desactivar`: desactivar.
- `DELETE /almacen-tipos/{id}`: eliminar.

#### Catálogo de tipos de movimiento (maestro) (`ArticuloMovTipoController`)
Ruta base: `/maestros/tipos-movimiento-catalogo`
- `GET /maestros/tipos-movimiento-catalogo`: lista paginada.
- `GET /maestros/tipos-movimiento-catalogo/{id}`: detalle.
- `POST /maestros/tipos-movimiento-catalogo`: crear.
- `PUT /maestros/tipos-movimiento-catalogo/{id}`: actualizar.
- `PATCH /maestros/tipos-movimiento-catalogo/{id}/activar`: activar.
- `PATCH /maestros/tipos-movimiento-catalogo/{id}/desactivar`: desactivar.
- `DELETE /maestros/tipos-movimiento-catalogo/{id}`: eliminar.

#### Tipos de movimiento (vista/CRUD alterno) (`TipoMovimientoController`)
Ruta base: `/tipos-movimiento`
- `GET /tipos-movimiento`: lista paginada.
- `GET /tipos-movimiento/{id}`: detalle.
- `POST /tipos-movimiento`: crear.
- `PUT /tipos-movimiento/{id}`: actualizar.
- `PATCH /tipos-movimiento/{id}/activar`: activar.
- `PATCH /tipos-movimiento/{id}/desactivar`: desactivar.
- `DELETE /tipos-movimiento/{id}`: eliminar.

#### Motivos de traslado (`MotivoTrasladoController`)
Ruta base: `/maestros/motivos-traslado`
- `GET /maestros/motivos-traslado`: lista paginada.
- `GET /maestros/motivos-traslado/{id}`: detalle.
- `POST /maestros/motivos-traslado`: crear.
- `PUT /maestros/motivos-traslado/{id}`: actualizar.
- `PATCH /maestros/motivos-traslado/{id}/activar`: activar.
- `PATCH /maestros/motivos-traslado/{id}/desactivar`: desactivar.
- `DELETE /maestros/motivos-traslado/{id}`: eliminar.

#### Artículo bonificación (`ArticuloBonificacionController`)
Ruta base: `/maestros/articulo-bonificaciones`
- `GET /maestros/articulo-bonificaciones?articuloId=`: lista paginada (opcional por artículo).
- `GET /maestros/articulo-bonificaciones/{id}`: detalle.
- `POST /maestros/articulo-bonificaciones`: crear.
- `PUT /maestros/articulo-bonificaciones/{id}`: actualizar.
- `PATCH /maestros/articulo-bonificaciones/{id}/activar`: activar.
- `PATCH /maestros/articulo-bonificaciones/{id}/desactivar`: desactivar.
- `DELETE /maestros/articulo-bonificaciones/{id}`: eliminar.

#### Lotes / pallets (`LotePalletController`)
- `GET /lotes-pallets?almacenId=&articuloId=`: lista paginada (filtros opcionales).
- `GET /lotes-pallets/{id}`: detalle.
- `POST /lotes-pallets`: crear.
- `PUT /lotes-pallets/{id}`: actualizar.
- `PATCH /lotes-pallets/{id}/activar`: activar.
- `PATCH /lotes-pallets/{id}/desactivar`: desactivar.

#### Ubicaciones (`UbicacionAlmacenController`)
Ruta base: `/ubicaciones`
- `PUT /ubicaciones/{id}`: actualizar ubicación.
- `DELETE /ubicaciones/{id}`: eliminar ubicación.

Además, hay sub-recursos de ubicación dentro de almacenes (ver `AlmacenController`).

---

### B. Almacenes (estructura) y asignaciones (`AlmacenController`)

#### CRUD de almacenes
- `GET /almacenes`: lista paginada.
- `GET /almacenes/{id}`: detalle.
- `POST /almacenes`: crear.
- `PUT /almacenes/{id}`: actualizar.
- `PATCH /almacenes/{id}/activar`: activar.
- `PATCH /almacenes/{id}/desactivar`: desactivar.
- `DELETE /almacenes/{id}`: eliminar.

#### Usuarios asignados a almacén (`almacen.almacen_user`)
- `GET /almacenes/{almacenId}/usuarios`: listar asignaciones.
- `POST /almacenes/{almacenId}/usuarios`: asignar usuario.
- `DELETE /almacenes/{almacenId}/usuarios/{usuarioId}`: desasignar.

#### Tipos de movimiento permitidos por almacén (`almacen.almacen_tipo_mov`)
- `GET /almacenes/{almacenId}/tipos-movimiento`: listar permitidos (paginado).
- `POST /almacenes/{almacenId}/tipos-movimiento`: asignar tipo movimiento.
- `DELETE /almacenes/{almacenId}/tipos-movimiento/{articuloMovTipoId}`: desasignar.

#### Ubicaciones por almacén (sub-recurso)
- `GET /almacenes/{almacenId}/ubicaciones`: listar ubicaciones del almacén.
- `POST /almacenes/{almacenId}/ubicaciones`: crear ubicación dentro del almacén.

---

### C. Movimientos (vale de movimiento) (`ValeMovController`)

Este es el **núcleo operativo**: registra, actualiza y procesa movimientos (ingresos/salidas/ajustes) y expone utilidades de export/import y PDF.

- `GET /movimientos`: búsqueda paginada por filtros (sucursal/almacén/tipo/estado/fechas y referencias OC/OV).
- `GET /movimientos/{id}`: detalle del movimiento (cabecera + líneas).
- `POST /movimientos`: registrar movimiento (pendiente/procesable según reglas).
- `PUT /movimientos/{id}`: actualizar movimiento.
- `POST /movimientos/confirmar`: confirmar/procesar movimiento.
- `POST /movimientos/anular`: anular movimiento.

Devoluciones:
- `GET /movimientos/devolvible/{id}`: calcula si un movimiento puede devolverse y qué se devolvería.
- `POST /movimientos/devolucion`: crea el movimiento de devolución.

Excel:
- `GET /movimientos/exportar` y `POST /movimientos/exportar`: exportar a Excel (mismos filtros).
- `POST /movimientos/importar` (multipart): importar Excel.

PDF:
- `GET /movimientos/pdf/{id}` y `POST /movimientos/{id}/pdf`: genera/retorna PDF del vale.

---

### D. Órdenes de traslado (`OrdenTrasladoController`)

Orquesta un traslado entre almacenes (origen → destino) con estados y salidas auxiliares (Excel/PDF).

- `GET /ordenes-traslado`: búsqueda paginada (origen/destino/estado/fechas).
- `GET /ordenes-traslado/{id}`: detalle.
- `POST /ordenes-traslado`: crear.
- `PUT /ordenes-traslado/{id}`: actualizar.
- `PATCH /ordenes-traslado/{id}/estado?estado=`: cambio de estado genérico.
- `POST /ordenes-traslado/{id}/aprobar`: aprobar.
- `POST /ordenes-traslado/{id}/rechazar`: rechazar.
- `POST /ordenes-traslado/{id}/cerrar`: cerrar.
- `POST /ordenes-traslado/{id}/anular`: anular.

Export/PDF:
- `GET /ordenes-traslado/exportar` y `POST /ordenes-traslado/exportar`: exportar Excel.
- `GET /ordenes-traslado/{id}/pdf` y `POST /ordenes-traslado/{id}/pdf`: PDF.

---

### E. Guías de remisión (`GuiasRemisionController`)

Gestiona guías y su flujo de estados:

- `GET /guias-remision`: búsqueda paginada (sucursal/estado/serie/numero/fechas/destinatario).
- `GET /guias-remision/{id}`: detalle.
- `POST /guias-remision`: crear.
- `PUT /guias-remision/{id}`: actualizar.
- `POST /guias-remision/{id}/anular` y `PATCH /guias-remision/{id}/anular`: anular.
- `POST /guias-remision/{id}/en-transito`: cambiar a “en tránsito”.
- `POST /guias-remision/{id}/entregar`: marcar “entregada”.

---

### F. Toma de inventario / conteos (`InventarioConteoController`)

Permite registrar conteos y aplicar transiciones de estado (comparar/cerrar/anular):

- `GET /tomas-inventario`: búsqueda paginada (almacén/artículo/estado/fechas).
- `GET /tomas-inventario/{id}`: detalle.
- `POST /tomas-inventario`: crear.
- `PUT /tomas-inventario/{id}`: actualizar.

Estados:
- `POST` o `PATCH /tomas-inventario/{id}/comparar`
- `POST` o `PATCH /tomas-inventario/{id}/cerrar`
- `POST` o `PATCH /tomas-inventario/{id}/anular`

---

### G. Integraciones (`IntegracionAlmacenController`)

Endpoints para que otros microservicios disparen acciones que terminan en **movimientos** o ejecución de traslado.

- `POST /integraciones/recepcion-orden-compra`: genera **ingreso** a partir de una OC.
- `POST /integraciones/salida-orden-venta`: genera **salida** a partir de una OV.
- `POST /integraciones/traslado-ejecutar`: ejecuta un traslado (normalmente impacta stock y/o movimientos asociados).

---

### H. Procesos batch (`AlmacenProcesoController`)

Procesos operativos no CRUD (ejecutables por menú/operación):

- `POST /procesos/recalculo-precios-promedio`
- `POST /procesos/cuadre-stock`
- `POST /procesos/actualizacion-automatica`

---

### I. Administración / migraciones (`AdminMigrationController`)

Utilidad para aplicar cambios puntuales de estructura en runtime:

- `POST /admin/migrate`: aplica alter/index a `almacen.vale_mov` (columna `vale_mov_orig_id`).

### J. Seed demo (`TestDataAdminController`)

- `POST /api/almacen/admin/test-data/seed`: datos de demostración para desarrollo/QA.
- **Condición:** el controlador solo existe si `app.testdata.enabled=true` (por defecto **`APP_TESTDATA_ENABLED`** suele estar en `true` en `application.yml`; desactivar en prod con variable `false`).
- Sin flag: la ruta **no está registrada** (típicamente **404**).

Orquestación y detalle: [`05. Documentacion/orquestacion/ORQUESTACION_MS-ALMACEN.md`](../../05.%20Documentacion/orquestacion/ORQUESTACION_MS-ALMACEN.md).

## 3) Flujo típico (alto nivel)

1. Se configura la **estructura** (tipos de almacén → almacenes → ubicaciones).
2. Se define el **catálogo** de tipos de movimiento y su **asignación por almacén**.
3. Operación diaria:
   - Se registran **movimientos** (`/movimientos`) y se **confirman** para afectar stock.
   - Se gestionan **órdenes de traslado** y **guías** según el flujo logístico.
4. Integración:
   - Compras/Ventas llaman a `/integraciones/*` para generar movimientos desde OC/OV.
5. Control:
   - Se ejecutan **tomas de inventario** y se cierran/anulan según resultados.
   - Se usan procesos batch para cuadre/regularización.

