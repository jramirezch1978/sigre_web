# `ms-ventas` — resumen de lógica y endpoints

**Orquestación (secuencias por procedimiento + token):** [`../../05. Documentacion/orquestacion/ORQUESTACION_MS-VENTAS.md`](../../05.%20Documentacion/orquestacion/ORQUESTACION_MS-VENTAS.md)  
**Flujo completo con diagramas:** [`FLUJO_COMPLETO_MS_VENTAS.md`](./FLUJO_COMPLETO_MS_VENTAS.md)

Este documento resume **qué hace** el microservicio `ms-ventas` y **qué endpoints expone**, agrupados por módulos. Está pensado como guía rápida para entender flujos y responsabilidades (no reemplaza la orquestación detallada ni los contratos en `05. Documentacion/markdown/Contratos/ms-ventas/`).

> **Base URL (dev):** `https://api.dev.contabilidad.restaurant.pe`  
> **Prefijo común:** `/api/ventas`  
> **Token requerido:** Definitivo (Bearer JWT post-selección de empresa)  
> **Response wrapper:** `ApiResponse<T>` con `success/message/errorCode/data/timestamp`  
> **Puerto interno:** 9010 (no expuesto; todo el tráfico pasa por API Gateway puerto 9080)

---

## 1) Responsabilidad del microservicio (visión general)

`ms-ventas` implementa el **POS/restaurante** (operación diaria), maestros comerciales, documentos B2B (OV, proforma, cierre caja, promociones), cuentas por cobrar y módulos extendidos (propinas, reservaciones, créditos CxC).

- **Maestros**: punto de venta, mesas/zona, carta, canales de distribución, vendedor, servicios CxC, zonas comerciales (venta/despacho/reparto).
- **Operación POS**: comandas (cocina/barra), pedido por mesa, facturación simplificada (borrador → emitir → anular).
- **Documentos comerciales (Fase 4)**: OV B2B (activa → confirmada → cerrada), proforma (activa → vencida/convertida/anulada), cierre de caja (OPEN → CLOSED), descuentos/promociones.
- **CxC**: cuentas por cobrar con movimientos (cargo/abono/ajuste/anulación) y asiento contable vía Feign.
- **POS extendido**: propinas, reservaciones (+ detalle), créditos CxC por entidad.
- **Seed demo**: `TestDataAdminController` activo por `APP_TESTDATA_ENABLED`.

Patrón de implementación típico:

- **Controller**: valida request, delega al **Service**, arma respuesta `ApiResponse<T>`.
- **Service**: reglas de negocio + transacciones; auditoría desde `TenantContext`; usa `FeignClient` para integrar con `ms-contabilidad`.
- **Repository / JdbcTemplate**: persistencia en esquema `ventas`; validación de FKs en otros esquemas por queries nativas.
- **Common**: `NumeradorDocumentoService` para numeración automática (OV, proforma) → `core.fn_get_document_number`.

---

## 2) Módulos y endpoints (por controlador)

### A. Maestros comerciales y sala

Cada maestro CRUD (estándar) sigue este patrón:

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/` | Listar (paginado + filtros) |
| `GET` | `/{id}` | Obtener por ID |
| `POST` | `/` | Crear |
| `PUT` | `/{id}` | Actualizar |
| `PATCH` | `/{id}/activar` | Activar |
| `PATCH` | `/{id}/desactivar` | Desactivar |
| `DELETE` | `/{id}` | Eliminar (baja lógica) |

Las secciones siguientes listan solo las rutas adicionales (no CRUD estándar) y observaciones específicas.

#### Zonas comerciales — venta (`ZonaVentaController`) — `/zonas-venta`
- CRUD estándar + activar/desactivar.

#### Zonas comerciales — despacho (`ZonaDespachoController`) — `/zonas-despacho`
- CRUD estándar + activar/desactivar.

#### Zonas comerciales — reparto (`ZonaRepartoController`) — `/zonas-reparto`
- CRUD estándar + activar/desactivar.

#### Canal de distribución (`CanalDistribucionController`) — `/canales-distribucion`
- CRUD estándar + activar/desactivar.

#### Servicios CxC (`ServiciosCxCController`) — `/servicios-cxc`
- CRUD estándar + activar/desactivar.

#### Vendedor (`VendedorController`) — `/vendedores`
- CRUD estándar + activar/desactivar.
- Adicional: `GET /vendedores/usuario/{usuarioId}` (búsqueda por usuario).

#### Puntos de venta (`PuntoVentaController`) — `/puntos-venta`
- CRUD estándar + activar/desactivar.
- Adicional: `GET /puntos-venta/sucursal/{sucursalId}`.

#### Zonas del salón (`ZonaController`) — `/zonas`
- CRUD estándar + activar/desactivar.
- Adicionales: `GET /zonas/sucursal/{sucursalId}`, `GET /zonas/activas`.

#### Mesas (`MesaController`) — `/mesas`
- CRUD estándar + activar/desactivar.
- Adicionales: `GET /mesas/zona/{zonaId}`, `GET /mesas/estado/{estado}`, `GET /mesas/sucursal/{sucursalId}`.

#### Cartas (`CartaController`) — `/cartas`
- CRUD estándar + activar/desactivar.
- Adicional: `GET /cartas/sucursal/{sucursalId}`.
- `GET /cartas/{id}` incluye detalle de ítems en respuesta.

#### Ítems de carta (`CartaItemController`) — `/cartas/{cartaId}/items`
- `GET /cartas/{cartaId}/items`, `POST`, `PUT /{itemId}`, `DELETE /{itemId}`.

---

### B. Operación POS

#### Comandas (`ComandaController`) — `/comandas`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/comandas` | Listar (paginado; filtros: sucursal, PV, mesa, estado, fechas) |
| `GET` | `/comandas/{id}` | Detalle |
| `POST` | `/comandas` | Crear (cabecera + ítems) |
| `PUT` | `/comandas/{id}` | Actualizar (solo ACTIVA) |
| `POST` | `/comandas/{id}/items` | Agregar ítems |
| `PATCH` | `/comandas/{id}/estado` | Cambiar estado |
| `POST` | `/comandas/{id}/anular` | Anular |
| `PATCH` | `/comandas/{id}/activar` | Activar |
| `PATCH` | `/comandas/{id}/desactivar` | Desactivar |
| `DELETE` | `/comandas/{id}` | Eliminar |

#### Pedido por mesa (`PedidoMesaController`) — `/pedidos-mesa`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/pedidos-mesa` | Listar (paginado; filtros varios) |
| `GET` | `/pedidos-mesa/{id}` | Detalle |
| `POST` | `/pedidos-mesa` | Abrir sesión |
| `PUT` | `/pedidos-mesa/{id}` | Actualizar |
| `POST` | `/pedidos-mesa/{id}/cerrar` | Cerrar sesión |
| `POST` | `/pedidos-mesa/{id}/anular` | Anular |
| `PATCH` | `/pedidos-mesa/{id}/activar` | Activar |
| `PATCH` | `/pedidos-mesa/{id}/desactivar` | Desactivar |
| `DELETE` | `/pedidos-mesa/{id}` | Eliminar |

#### Factura simplificada (`FacturaSimplificadaController`) — `/facturas-simplificadas`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/facturas-simplificadas` | Listar (paginado + filtros) |
| `GET` | `/facturas-simplificadas/{id}` | Detalle con items y pagos |
| `POST` | `/facturas-simplificadas` | Registrar borrador |
| `PUT` | `/facturas-simplificadas/{id}` | Actualizar borrador |
| `POST` | `/facturas-simplificadas/{id}/emitir` | Emitir comprobante |
| `POST` | `/facturas-simplificadas/{id}/anular` | Anular (solo emitido; ver orquestación §6.1) |
| `GET` | `/facturas-simplificadas/{id}/pagos` | Listar pagos |
| `PATCH` | `/facturas-simplificadas/{id}/activar` | Activar |
| `PATCH` | `/facturas-simplificadas/{id}/desactivar` | Desactivar |
| `DELETE` | `/facturas-simplificadas/{id}` | Eliminar |

---

### C. Gestión crediticia (CxC)

#### Cuentas por cobrar (`CuentaCobrarController`) — `/cuentas-cobrar`

Protegido con `@PreAuthorize` (`VENTAS_CONSULTAR`, `VENTAS_CREAR`, `VENTAS_EDITAR`, `VENTAS_ELIMINAR`, `ADMIN` según método).

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/cuentas-cobrar` | Listar (paginado; filtros + sort) |
| `GET` | `/cuentas-cobrar/{id}` | Detalle con movimientos |
| `POST` | `/cuentas-cobrar` | Crear (cabecera + movimientos iniciales) |
| `PUT` | `/cuentas-cobrar/{id}` | Actualizar |
| `POST` | `/cuentas-cobrar/{id}/movimientos` | Registrar cargo/abono/ajuste |
| `GET` | `/cuentas-cobrar/{id}/movimientos` | Listar movimientos |
| `POST` | `/cuentas-cobrar/{id}/anular` | Anular (rechaza si hay abonos aplicados) |
| `PATCH` | `/cuentas-cobrar/{id}/activar` | Activar |
| `PATCH` | `/cuentas-cobrar/{id}/desactivar` | Desactivar |
| `DELETE` | `/cuentas-cobrar/{id}` | Eliminar (baja lógica) |

---

### D. Orden de venta (B2B), proforma, cierre de caja y promociones (Fase 4)

#### Orden de venta (`OrdenVentaController`) — `/ordenes-venta`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/ordenes-venta` | Listar (paginado + filtros; incluye líneas) |
| `GET` | `/ordenes-venta/{id}` | Detalle con líneas |
| `POST` | `/ordenes-venta` | Crear (numeración automática si `nroOrdenVenta` vacío) |
| `PUT` | `/ordenes-venta/{id}` | Actualizar |
| `PATCH` | `/ordenes-venta/{id}/confirmar` | Confirmar |
| `PATCH` | `/ordenes-venta/{id}/anular` | Anular |
| `PATCH` | `/ordenes-venta/{id}/cerrar` | Cerrar |

#### Proforma (`ProformaController`) — `/proformas`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/proformas` | Listar (solo cabecera; `detalles: null` por open-in-view=false) |
| `GET` | `/proformas/{id}` | Detalle **con** líneas |
| `POST` | `/proformas` | Crear (numeración automática si `numero` vacío; `sucursalId` obligatoria en ese caso) |
| `PUT` | `/proformas/{id}` | Actualizar |
| `PATCH` | `/proformas/{id}/anular` | Anular |
| `PATCH` | `/proformas/{id}/marcar-vencida` | Marcar vencida |
| `PATCH` | `/proformas/{id}/marcar-convertida` | Marcar convertida a OV |

#### Cierre de caja (`CierreCajaController`) — `/cierre-caja`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/cierre-caja` | Listar (paginado; filtros: `turnoId`, `abierto`) |
| `GET` | `/cierre-caja/{id}` | Detalle |
| `POST` | `/cierre-caja` | Apertura de turno |
| `PATCH` | `/cierre-caja/{id}/cerrar` | Cerrar turno (cambia `estadoCierre` a `CLOSED`) |

#### Descuentos y promociones (`DescuentoPromocionController`) — `/descuentos-promocion`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/descuentos-promocion` | Listar (paginado; filtros: `nombre`, `tipo`, `flagEstado`) |
| `GET` | `/descuentos-promocion/{id}` | Detalle |
| `POST` | `/descuentos-promocion` | Alta |
| `PUT` | `/descuentos-promocion/{id}` | Actualizar |
| `PATCH` | `/descuentos-promocion/{id}/activar` | Activar |
| `PATCH` | `/descuentos-promocion/{id}/desactivar` | Desactivar |
| `DELETE` | `/descuentos-promocion/{id}` | Eliminar |

Response puede incluir `vigenciaDerivada` calculado: `OFF`, `SCHEDULED`, `ON`, `EXPIRED`.

---

### E. Propinas, reservaciones y límites de crédito CxC (issue 5)

| Área | Base API | Controller |
|------|----------|------------|
| Propinas | `/api/ventas/propinas` | `PropinaController` — CRUD + activar/desactivar |
| Reservaciones | `/api/ventas/reservaciones` | `ReservacionController` — CRUD + confirmar/cancelar + activar/desactivar |
| Créditos por entidad | `/api/ventas/creditos-cxc` | `EntidadCreditosCxcController` — CRUD + activar/desactivar |

Endpoints detallados en contratos respectivos (`05. Documentacion/markdown/Contratos/ms-ventas/`).

---

### F. Administración / demo

#### Seed de datos (`TestDataAdminController`) — `/admin/test-data`

| Método | Ruta | Descripción |
|--------|------|-------------|
| `POST` | `/admin/test-data/seed` | Carga demo masiva. **403** si `APP_TESTDATA_ENABLED=false` (código `TESTDATA_DISABLED`). |

> Por defecto `app.testdata.enabled: true` en `application.yml`. Desactivar en producción con `APP_TESTDATA_ENABLED=false`.

**Postman Fase 4:** [`postman/ms-ventas-fase4-ov-proforma-cierre-descuentos.postman_collection.json`](./postman/ms-ventas-fase4-ov-proforma-cierre-descuentos.postman_collection.json).

---

## 3) Integraciones vía Feign

| Cliente Feign | MS destino | Endpoints |
|---------------|------------|-----------|
| `ContabilidadClient` | `ms-contabilidad` (9006) | `POST /api/contabilidad/asientos/generar/registro-cntas-cobrar` |
| `AlmacenClient` | `ms-almacen` (9003) | *Pendiente (roadmap issue 5)* |

**Lectura de maestros externos** (sin Feign, vía JPA `@ManyToOne`/`@OneToOne` con tablas Ref): `core.articulo`, `core.entidad_contribuyente`, `core.moneda`, `core.doc_tipo`, `core.forma_pago`, `core.unidad_medida`, `auth.sucursal`, `auth.usuario`, `almacen.almacen`.

---

## 4) Flujo típico (alto nivel)

1. **Configurar maestros** → zonas, canales, servicios CxC, vendedores, PV, zonas salón, mesas, carta con items.
2. **Operación POS diaria:**
   - Abrir pedido mesa → registrar comandas con items → emitir factura simplificada (borrador → emitir).
   - Opcional: anular factura (valida reservaciones, desactiva propinas, anula CxC).
3. **Operación B2B:**
   - Crear OV → confirmar → despachar stock (ms-almacen) → cerrar OV.
   - Crear proforma → marcar vencida/convertida/anulada.
4. **Cierre de caja:** apertura de turno → cerrar turno con cuadre.
5. **Gestión crediticia:** crear CxC → registrar movimientos (cargo/abono) → anular (si no hay abonos).
6. **POS extendido:** propinas, reservaciones, créditos CxC por entidad.

---

## 5) Reglas de negocio críticas

1. **Token definitivo obligatorio** — todos los endpoints `/api/ventas/**` requieren JWT post-selección de empresa.
2. **CxC requiere `conceptoFinancieroId`** — cada movimiento de CxC debe referenciar un concepto financiero existente en `finanzas.concepto_financiero`.
3. **OV editable hasta despacho** — la OV confirmada se puede editar hasta que el primer item sea despachado (por línea: hasta que esa línea sea despachada).
4. **Factura anulada → propinas desactivadas** — al anular una factura emitida, las propinas vinculadas se desactivan automáticamente en la misma transacción.
5. **Reservación confirmada bloquea anulación** — si existe una reservación `CONFIRMADA` vinculada a la factura, la anulación se rechaza (`VEN-088`).
6. **CxC con abonos no permite anular** — si la cuenta tiene movimientos de tipo `ABONO` aplicados, la anulación falla con `VEN-STATE`.
7. **Listado proformas sin líneas** — `GET /proformas` devuelve `detalles: null` (open-in-view=false); el detalle completo va en `GET /proformas/{id}`.
8. **Numeración automática 12 caracteres** — OV y proforma usan `NumeradorDocumentoService` → `core.fn_get_document_number(tabla, sucursalId, año)`.
9. **Seed deshabilitado en producción** — `APP_TESTDATA_ENABLED=false` protege el endpoint `/admin/test-data/seed` (responde 403).

---

## 6) Errores estandarizados (`VentasErrorCodes`)

| Rango/Constante | Código | Módulo |
|-----------------|--------|--------|
| `FS_STATE` | `VEN-081` | Factura simplificada — estado inválido para operación |
| `FS_ANULAR_RESERVACION_PENDIENTE` | `VEN-088` | Factura — reservación confirmada bloquea anulación |
| `OV_STATE` | `VEN-091` | Orden de venta — transición de estado no permitida |
| `OV_NUMERO_DUPLICADO` | `VEN-092` | Orden de venta — `nro_orden_venta` repetido |
| `PROFORMA_STATE` | `VEN-101` | Proforma — estado incompatible |
| `PROFORMA_NUMERO_DUPLICADO` | `VEN-102` | Proforma — `numero` repetido |
| `PROFORMA_SUCURSAL_REQUIRED` | `VEN-103` | Proforma — `sucursalId` obligatoria si `numero` se autogenera |
| `CIERRE_CAJA_STATE` | `VEN-111` | Cierre de caja — turno con cierre abierto / ya finalizado |
| `DESCUENTO_PROMOCION_INVALIDO` | `VEN-121` | Descuento/promoción — reglas de tipo/datos |
| `VEN-STATE` | — | Estado inválido genérico / CxC con abonos no anulable |

No encontrado por id → **`RESOURCE_NOT_FOUND`** (404) con mensaje estándar del handler.  
Errores de validación → **`VALIDATION_ERROR`** con detalles de campo.

---

## 7) Documentos relacionados

- Visión global y diagramas: [`FLUJO_COMPLETO_MS_VENTAS.md`](./FLUJO_COMPLETO_MS_VENTAS.md)
- Procesos POS / CxC / seed: [`PROCESOS_VENTAS.md`](./PROCESOS_VENTAS.md)
- Orquestación detallada con requests HTTP: [`../../05. Documentacion/orquestacion/ORQUESTACION_MS-VENTAS.md`](../../05.%20Documentacion/orquestacion/ORQUESTACION_MS-VENTAS.md)
- Contratos e historias de usuario: `05. Documentacion/markdown/Contratos/ms-ventas/*.md`
- Índice carpeta interna: [`docs/README.md`](./docs/README.md)
