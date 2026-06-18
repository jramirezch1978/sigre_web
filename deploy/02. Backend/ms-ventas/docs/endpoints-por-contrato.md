# Listado Completo de Endpoints - ms-ventas

> **Documento:** Listado de todos los endpoints esperados según contratos técnicos e historias de usuario  
> **Generado:** 30/04/2026 10:31:00  
> **Última actualización:** 03/05/2026 22:55:00  
> **Contratos base:** 13 archivos CONTRATO_*.md  
> **Historias de Usuario:** 13 archivos HU_*.md  
> **Estado implementación:** Basado en VERIFICACION_CONTRATO_VS_IMPLEMENTACION.md  
> **Fase 1 implementada:** ✅ 100% (67/67 endpoints)  
> **Fase 2 implementada:** ✅ 100% (30/30 endpoints)  
> **Fase 3 implementada:** ✅ 100% (10/10 endpoints)  

---

## FASE 1: MAESTROS FUNDAMENTALES (Tarea 1)

### 1.1 Módulo: Punto de Venta
**Contrato:** `CONTRATO_PUNTO_VENTA.md`  
**Historia de Usuario:** `HU_PUNTO_VENTA.md`  
**Tabla:** `ventas.punto_venta`  
**Estado implementación:** ✅ **CUMPLE**

| # | Método | Endpoint | Descripción del Contrato | Response |
|---|--------|----------|-------------------------|----------|
| 1 | `GET` | `/api/ventas/puntos-venta` | Lista paginada con filtros `sucursalId, codigo, nombre, flagEstado`. Administra cajas o frentes de atención por sucursal. | `ApiResponse<PageResponse<PuntoVentaListItemResponse>>` |
| 2 | `GET` | `/api/ventas/puntos-venta/{id}` | Obtiene detalle por id. Incluye datos descriptivos de FK (sucursalNombre, almacenNombre). | `ApiResponse<PuntoVentaResponse>` |
| 3 | `POST` | `/api/ventas/puntos-venta` | Crea el recurso. Valida que código sea único por sucursal. Campos: sucursalId, almacenId, codigo, nombre, serieBoleta, serieFactura, tipoImpresora. | `ApiResponse<PuntoVentaResponse>` (HTTP 201) |
| 4 | `PUT` | `/api/ventas/puntos-venta/{id}` | Actualiza todos los campos editables. Valida unicidad de código por sucursal. | `ApiResponse<PuntoVentaResponse>` |
| 5 | `PATCH` | `/api/ventas/puntos-venta/{id}/activar` | Activa el recurso. Cambia flagEstado a "1". | `ApiResponse<PuntoVentaResponse>` |
| 6 | `PATCH` | `/api/ventas/puntos-venta/{id}/desactivar` | Desactiva o bloquea según reglas. Cambia flagEstado a "0". | `ApiResponse<PuntoVentaResponse>` |
| 7 | `DELETE` | `/api/ventas/puntos-venta/{id}` | Baja lógica si no tiene uso operativo bloqueante. | `ApiResponse<Void>` |

**Validaciones específicas:**
- El código debe ser único por sucursal
- Las series no deben duplicarse para el mismo punto de emisión
- Validar existencia y estado activo de sucursal y almacén

---

### 1.2 Módulo: Mesa
**Contrato:** `CONTRATO_MESA.md`  
**Historia de Usuario:** `HU_MESA.md`  
**Tabla:** `ventas.mesa`  
**Estado implementación:** ✅ **CUMPLE**

| # | Método | Endpoint | Descripción del Contrato | Response |
|---|--------|----------|-------------------------|----------|
| 8 | `GET` | `/api/ventas/mesas` | Lista paginada con filtros `zonaId, numero, estado, flagEstado`. Administra mesas físicas del salón por zona. | `ApiResponse<PageResponse<MesaListItemResponse>>` |
| 9 | `GET` | `/api/ventas/mesas/{id}` | Obtiene detalle por id. Incluye zonaNombre derivado por JOIN. Estados: LIBRE, OCUPADA, RESERVADA, BLOQUEADA. | `ApiResponse<MesaResponse>` |
| 10 | `POST` | `/api/ventas/mesas` | Crea el recurso. Campos: zonaId, numero, capacidad, estado. El número debe ser UNIQUE. | `ApiResponse<MesaResponse>` (HTTP 201) |
| 11 | `PUT` | `/api/ventas/mesas/{id}` | Actualiza todos los campos editables. Valida que mesa no esté ocupada para desactivación. | `ApiResponse<MesaResponse>` |
| 12 | `PATCH` | `/api/ventas/mesas/{id}/activar` | Activa el recurso. Cambia flagEstado a "1". | `ApiResponse<MesaResponse>` |
| 13 | `PATCH` | `/api/ventas/mesas/{id}/desactivar` | Desactiva o bloquea según reglas. Una mesa ocupada no puede desactivarse. | `ApiResponse<MesaResponse>` |
| 14 | `DELETE` | `/api/ventas/mesas/{id}` | Baja lógica si no tiene uso operativo bloqueante. | `ApiResponse<Void>` |

**Validaciones específicas:**
- Una mesa ocupada no puede eliminarse ni desactivarse
- El número de mesa debe ser único
- Validar existencia y estado activo de la zona

---

### 1.3 Módulo: Vendedor
**Contrato:** `CONTRATO_VENDEDOR.md`  
**Historia de Usuario:** `HU_VENDEDOR.md`  
**Tabla:** `ventas.vendedor`  
**Estado implementación:** ✅ **CUMPLE**

| # | Método | Endpoint | Descripción del Contrato | Response |
|---|--------|----------|-------------------------|----------|
| 15 | `GET` | `/api/ventas/vendedores` | Lista paginada con filtros `usuarioId, nombre, flagEstado`. Registra usuarios habilitados como vendedores o meseros. | `ApiResponse<PageResponse<VendedorListItemResponse>>` |
| 16 | `GET` | `/api/ventas/vendedores/{id}` | Obtiene detalle por id. Campos: usuarioId, nombre, comisionPorcentaje, flagEstado, audit. | `ApiResponse<VendedorResponse>` |
| 17 | `POST` | `/api/ventas/vendedores` | Crea el recurso. Campos: usuarioId (obligatorio), nombre, comisionPorcentaje (0-100). | `ApiResponse<VendedorResponse>` (HTTP 201) |
| 18 | `PUT` | `/api/ventas/vendedores/{id}` | Actualiza todos los campos editables. La comisión no puede ser negativa ni mayor a 100. | `ApiResponse<VendedorResponse>` |
| 19 | `PATCH` | `/api/ventas/vendedores/{id}/activar` | Activa el recurso. | `ApiResponse<VendedorResponse>` |
| 20 | `PATCH` | `/api/ventas/vendedores/{id}/desactivar` | Desactiva o bloquea según reglas. | `ApiResponse<VendedorResponse>` |
| 21 | `DELETE` | `/api/ventas/vendedores/{id}` | Baja lógica si no tiene uso operativo bloqueante. | `ApiResponse<Void>` |

**Validaciones específicas:**
- El usuario debe existir y estar activo
- La comisión no puede ser negativa ni mayor a 100
- El usuarioId es clave natural única

---

### 1.4 Módulo: Canal de Distribución
**Contrato:** `CONTRATO_CANAL_DISTRIBUCION.md`  
**Historia de Usuario:** `HU_CANAL_DISTRIBUCION.md`  
**Tabla:** `ventas.canal_distribucion`  
**Estado implementación:** ✅ **CUMPLE**

| # | Método | Endpoint | Descripción del Contrato | Response |
|---|--------|----------|-------------------------|----------|
| 22 | `GET` | `/api/ventas/canales-distribucion` | Lista paginada con filtros `codigo, nombre, flagEstado`. Clasifica ventas por canal comercial, delivery, salón, web. | `ApiResponse<PageResponse<CanalDistribucionListItemResponse>>` |
| 23 | `GET` | `/api/ventas/canales-distribucion/{id}` | Obtiene detalle por id. Campos: codigo, nombre, flagEstado, audit. | `ApiResponse<CanalDistribucionResponse>` |
| 24 | `POST` | `/api/ventas/canales-distribucion` | Crea el recurso. Campos: codigo (obligatorio, UNIQUE), nombre. El código debe ser estable para reportes. | `ApiResponse<CanalDistribucionResponse>` (HTTP 201) |
| 25 | `PUT` | `/api/ventas/canales-distribucion/{id}` | Actualiza todos los campos editables. | `ApiResponse<CanalDistribucionResponse>` |
| 26 | `PATCH` | `/api/ventas/canales-distribucion/{id}/activar` | Activa el recurso. | `ApiResponse<CanalDistribucionResponse>` |
| 27 | `PATCH` | `/api/ventas/canales-distribucion/{id}/desactivar` | Desactiva o bloquea según reglas. | `ApiResponse<CanalDistribucionResponse>` |
| 28 | `DELETE` | `/api/ventas/canales-distribucion/{id}` | Baja lógica si no tiene uso operativo bloqueante. | `ApiResponse<Void>` |

**Validaciones específicas:**
- El código debe ser estable porque puede usarse en reportes e integraciones
- El código debe ser único

---

### 1.5 Módulo: Carta / Menú
**Contrato:** `CONTRATO_CARTA_MENU.md`  
**Historia de Usuario:** `HU_CARTA_MENU.md`  
**Tablas:** `ventas.carta, ventas.carta_det`  
**Estado implementación:** ✅ **CUMPLE**

| # | Método | Endpoint | Descripción del Contrato | Response |
|---|--------|----------|-------------------------|----------|
| 29 | `GET` | `/api/ventas/cartas` | Lista paginada con filtros `sucursalId, nombre, articuloId, flagEstado`. Mantiene cartas de venta por sucursal. | `ApiResponse<PageResponse<CartaMenuListItemResponse>>` |
| 30 | `GET` | `/api/ventas/cartas/{id}` | Obtiene detalle por id con sus ítems. Incluye: sucursalNombre, items[].articuloNombre. | `ApiResponse<CartaMenuResponse>` |
| 31 | `POST` | `/api/ventas/cartas` | Crea el recurso cabecera + detalle. Campos cabecera: sucursalId, nombre, descripcion. Campos ítems: articuloId, precio, orden. | `ApiResponse<CartaMenuResponse>` (HTTP 201) |
| 32 | `PUT` | `/api/ventas/cartas/{id}` | Actualiza solo cabecera (sin items). Campos: sucursalId, nombre, descripcion. | `ApiResponse<CartaMenuResponse>` |
| 33 | `PATCH` | `/api/ventas/cartas/{id}/activar` | Activa el recurso. | `ApiResponse<CartaMenuResponse>` |
| 34 | `PATCH` | `/api/ventas/cartas/{id}/desactivar` | Desactiva o bloquea según reglas. | `ApiResponse<CartaMenuResponse>` |
| 35 | `DELETE` | `/api/ventas/cartas/{id}` | Baja lógica si no tiene uso operativo bloqueante. | `ApiResponse<Void>` |
| 36 | `GET` | `/api/ventas/cartas/{id}/items` | Lista ítems de la carta. Incluye articuloNombre derivado por JOIN. | `ApiResponse<List<CartaItemResponse>>` |
| 37 | `POST` | `/api/ventas/cartas/{id}/items` | Agrega ítem a la carta. Campos: articuloId, precio (>=0), orden. Valida que artículo no se repita activo. | `ApiResponse<CartaItemResponse>` |
| 38 | `PUT` | `/api/ventas/cartas/{id}/items/{itemId}` | Actualiza precio/orden del ítem. Campos: precio, orden. | `ApiResponse<CartaItemResponse>` |
| 39 | `DELETE` | `/api/ventas/cartas/{id}/items/{itemId}` | Baja lógica del ítem. | `ApiResponse<Void>` |

**Validaciones específicas:**
- Un artículo no debe repetirse activo dentro de la misma carta
- El precio debe ser mayor o igual a cero
- Validar existencia y estado activo de sucursal y artículos

---

### 1.6 Módulo: Servicios CxC
**Contrato:** `CONTRATO_SERVICIOS_CXC.md`  
**Historia de Usuario:** `HU_SERVICIOS_CXC.md`  
**Tabla:** `ventas.servicios_cxc`  
**Estado implementación:** ✅ **CUMPLE**

| # | Método | Endpoint | Descripción del Contrato | Response |
|---|--------|----------|-------------------------|----------|
| 40 | `GET` | `/api/ventas/servicios-cxc` | Lista paginada con filtros `codServicio, descServicio, codMoneda, flagEstado`. Registra servicios facturables que generan CxC sin inventario. | `ApiResponse<PageResponse<ServiciosCxcListItemResponse>>` |
| 41 | `GET` | `/api/ventas/servicios-cxc/{id}` | Obtiene detalle por id. Campos: codServicio, descServicio, tarifa, codMoneda, flagAfectoIgv, flagReplicacion, flagEstado, audit. | `ApiResponse<ServiciosCxcResponse>` |
| 42 | `POST` | `/api/ventas/servicios-cxc` | Crea el recurso. Campos: codServicio (CHAR(3), UNIQUE, obligatorio), descServicio, tarifa (no negativa), codMoneda, flagAfectoIgv (1/0), flagReplicacion. | `ApiResponse<ServiciosCxcResponse>` (HTTP 201) |
| 43 | `PUT` | `/api/ventas/servicios-cxc/{id}` | Actualiza todos los campos editables. La tarifa no puede ser negativa. | `ApiResponse<ServiciosCxcResponse>` |
| 44 | `PATCH` | `/api/ventas/servicios-cxc/{id}/activar` | Activa el recurso. | `ApiResponse<ServiciosCxcResponse>` |
| 45 | `PATCH` | `/api/ventas/servicios-cxc/{id}/desactivar` | Desactiva o bloquea según reglas. | `ApiResponse<ServiciosCxcResponse>` |
| 46 | `DELETE` | `/api/ventas/servicios-cxc/{id}` | Baja lógica si no tiene uso operativo bloqueante. | `ApiResponse<Void>` |

**Validaciones específicas:**
- La tarifa no puede ser negativa
- flagAfectoIgv acepta valores 1/0
- El código de servicio debe ser único (CHAR(3))

---

### 1.7 Módulo: Zona de Venta
**Contrato:** `CONTRATO_ZONA_VENTA.md`  
**Historia de Usuario:** `HU_ZONA_VENTA.md`  
**Tabla:** `ventas.vta_zona_venta`  
**Estado implementación:** ✅ **CUMPLE**

| # | Método | Endpoint | Descripción del Contrato | Response |
|---|--------|----------|-------------------------|----------|
| 47 | `GET` | `/api/ventas/zonas-venta` | Lista paginada con filtros `zonaVenta, descZonaVenta, ubigeo, flagEstado`. Clasifica clientes, rutas o territorios comerciales. | `ApiResponse<PageResponse<ZonaVentaListItemResponse>>` |
| 48 | `GET` | `/api/ventas/zonas-venta/{id}` | Obtiene detalle por id. Campos: zonaVenta, descZonaVenta, ubigeo, flagEstado, audit. | `ApiResponse<ZonaVentaResponse>` |
| 49 | `POST` | `/api/ventas/zonas-venta` | Crea el recurso. Campos: zonaVenta (VARCHAR(8), UNIQUE, obligatorio), descZonaVenta, ubigeo. | `ApiResponse<ZonaVentaResponse>` (HTTP 201) |
| 50 | `PUT` | `/api/ventas/zonas-venta/{id}` | Actualiza todos los campos editables. El ubigeo, si se informa, debe existir en maestro geográfico. | `ApiResponse<ZonaVentaResponse>` |
| 51 | `PATCH` | `/api/ventas/zonas-venta/{id}/activar` | Activa el recurso. | `ApiResponse<ZonaVentaResponse>` |
| 52 | `PATCH` | `/api/ventas/zonas-venta/{id}/desactivar` | Desactiva o bloquea según reglas. | `ApiResponse<ZonaVentaResponse>` |
| 53 | `DELETE` | `/api/ventas/zonas-venta/{id}` | Baja lógica si no tiene uso operativo bloqueante. | `ApiResponse<Void>` |

**Validaciones específicas:**
- El código de zona debe ser único
- El ubigeo, si se informa, debe existir en maestro geográfico

---

### 1.8 Módulo: Zona de Despacho
**Contrato:** `CONTRATO_ZONA_DESPACHO.md`  
**Historia de Usuario:** `HU_ZONA_DESPACHO.md`  
**Tabla:** `ventas.vta_zona_despacho`  
**Estado implementación:** ✅ **CUMPLE**

| # | Método | Endpoint | Descripción del Contrato | Response |
|---|--------|----------|-------------------------|----------|
| 54 | `GET` | `/api/ventas/zonas-despacho` | Lista paginada con filtros `zonaDespacho, descZonaDespacho, ubigeo, flagEstado`. Agrupa destinos para preparación y salida logística. | `ApiResponse<PageResponse<ZonaDespachoListItemResponse>>` |
| 55 | `GET` | `/api/ventas/zonas-despacho/{id}` | Obtiene detalle por id. Campos: zonaDespacho, descZonaDespacho, ubigeo, flagEstado, audit. | `ApiResponse<ZonaDespachoResponse>` |
| 56 | `POST` | `/api/ventas/zonas-despacho` | Crea el recurso. Campos: zonaDespacho (VARCHAR(8), UNIQUE, obligatorio), descZonaDespacho, ubigeo. | `ApiResponse<ZonaDespachoResponse>` (HTTP 201) |
| 57 | `PUT` | `/api/ventas/zonas-despacho/{id}` | Actualiza todos los campos editables. La zona solo puede usarse en operaciones si está activa. | `ApiResponse<ZonaDespachoResponse>` |
| 58 | `PATCH` | `/api/ventas/zonas-despacho/{id}/activar` | Activa el recurso. | `ApiResponse<ZonaDespachoResponse>` |
| 59 | `PATCH` | `/api/ventas/zonas-despacho/{id}/desactivar` | Desactiva o bloquea según reglas. | `ApiResponse<ZonaDespachoResponse>` |
| 60 | `DELETE` | `/api/ventas/zonas-despacho/{id}` | Baja lógica si no tiene uso operativo bloqueante. | `ApiResponse<Void>` |

**Validaciones específicas:**
- La zona solo puede usarse en operaciones si está activa
- El código de zona debe ser único

---

### 1.9 Módulo: Zona de Reparto
**Contrato:** `CONTRATO_ZONA_REPARTO.md`  
**Historia de Usuario:** `HU_ZONA_REPARTO.md`  
**Tabla:** `ventas.vta_zona_reparto`  
**Estado implementación:** ✅ **CUMPLE**

| # | Método | Endpoint | Descripción del Contrato | Response |
|---|--------|----------|-------------------------|----------|
| 61 | `GET` | `/api/ventas/zonas-reparto` | Lista paginada con filtros `zonaReparto, descZonaReparto, ubigeo, flagEstado`. Organiza zonas de delivery/reparto. | `ApiResponse<PageResponse<ZonaRepartoListItemResponse>>` |
| 62 | `GET` | `/api/ventas/zonas-reparto/{id}` | Obtiene detalle por id. Campos: zonaReparto, descZonaReparto, ubigeo, flagEstado, audit. | `ApiResponse<ZonaRepartoResponse>` |
| 63 | `POST` | `/api/ventas/zonas-reparto` | Crea el recurso. Campos: zonaReparto (VARCHAR(8), UNIQUE, obligatorio), descZonaReparto, ubigeo. | `ApiResponse<ZonaRepartoResponse>` (HTTP 201) |
| 64 | `PUT` | `/api/ventas/zonas-reparto/{id}` | Actualiza todos los campos editables. | `ApiResponse<ZonaRepartoResponse>` |
| 65 | `PATCH` | `/api/ventas/zonas-reparto/{id}/activar` | Activa el recurso. | `ApiResponse<ZonaRepartoResponse>` |
| 66 | `PATCH` | `/api/ventas/zonas-reparto/{id}/desactivar` | Desactiva o bloquea según reglas. No debe desactivarse si está referenciada por pedidos activos. | `ApiResponse<ZonaRepartoResponse>` |
| 67 | `DELETE` | `/api/ventas/zonas-reparto/{id}` | Baja lógica si no tiene uso operativo bloqueante. | `ApiResponse<Void>` |

**Validaciones específicas:**
- No debe desactivarse si está referenciada por pedidos o reglas activas de reparto
- El código de zona debe ser único

---

## FASE 2: OPERACIONES BÁSICAS DE VENTA (Tarea 2)

### 2.1 Módulo: Comanda
**Contrato:** `CONTRATO_COMANDA.md`  
**Historia de Usuario:** `HU_COMANDA.md`  
**Tablas:** `ventas.comanda, ventas.comanda_det, ventas.comanda_seguimiento`  
**Estado implementación:** ✅ **CUMPLE**

| # | Método | Endpoint | Descripción del Contrato | Response Implementado | ✅ Validado |
|---|--------|----------|-------------------------|----------------------|------------|
| 68 | `GET` | `/api/ventas/comandas` | Lista paginada con filtros `sucursalId, puntoVentaId, mesa, estado, fechaDesde, fechaHasta`. Estados: ABIERTA, EN_PREPARACION, ATENDIDA, ANULADA. | `ApiResponse<PageResponse<ComandaResponse>>` | ✅ |
| 69 | `GET` | `/api/ventas/comandas/{id}` | Obtiene detalle por id con sus ítems. Incluye datos derivados: sucursalNombre, puntoVentaNombre, clienteRazonSocial, articuloNombre. | `ApiResponse<ComandaResponse>` | ✅ |
| 70 | `POST` | `/api/ventas/comandas` | Crea el recurso cabecera + detalle. Campos: sucursalId, puntoVentaId, turnoId, clienteId, mesa, items[]. Calcula subtotal y total automáticamente. | `ApiResponse<ComandaResponse>` (HTTP 201) | ✅ |
| 71 | `PUT` | `/api/ventas/comandas/{id}` | Actualiza campos editables de cabecera (sin items). Campos: sucursalId, puntoVentaId, turnoId, clienteId, mesa. Solo comandas ABIERTAS pueden modificarse. | `ApiResponse<ComandaResponse>` | ✅ |
| 72 | `PATCH` | `/api/ventas/comandas/{id}/activar` | Activa el recurso. Cambia flagEstado a "1". | `ApiResponse<ComandaResponse>` | ✅ |
| 73 | `PATCH` | `/api/ventas/comandas/{id}/desactivar` | Desactiva o bloquea según reglas. Cambia flagEstado a "0". | `ApiResponse<ComandaResponse>` | ✅ |
| 74 | `DELETE` | `/api/ventas/comandas/{id}` | Baja lógica si no tiene uso operativo bloqueante. | `ApiResponse<Void>` | ✅ |
| 75 | `POST` | `/api/ventas/comandas/{id}/items` | Agrega ítems a comanda abierta. Request: `{ "items": [...] }`. Solo comandas ABIERTAS pueden recibir ítems. | `ApiResponse<ComandaResponse>` | ✅ |
| 76 | `PATCH` | `/api/ventas/comandas/{id}/estado` | Cambia estado operativo. Request: `{ "estado": "ATENDIDA", "motivo": "..." }`. | `ApiResponse<ComandaResponse>` | ✅ |
| 77 | `POST` | `/api/ventas/comandas/{id}/anular` | Anula la comanda con motivo. Request: `{ "motivo": "..." }`. Estado pasa a ANULADA. | `ApiResponse<ComandaResponse>` | ✅ |

**✅ Formato de respuesta validado:**
- `ApiResponse<T>` con estructura estándar
- Timestamp en formato `dd/MM/yyyy HH:mm:ss` (America/Lima)
- Auditoría contractual: `flagEstado`, `createdBy`, `fecCreacion`, `updatedBy`, `fecModificacion`
- Campos derivados por JOIN: `sucursalNombre`, `puntoVentaNombre`, `clienteRazonSocial`, `articuloNombre`

**Validaciones específicas:**
- Solo comandas ABIERTAS pueden recibir cambios de ítems
- ATENDIDA no permite edición ni baja lógica
- Validar stock (integración con ms-almacén)
- Estados permitidos: ABIERTA → EN_PREPARACION → ATENDIDA → ANULADA

---

### 2.2 Módulo: Pedido Mesa
**Contrato:** `CONTRATO_PEDIDO_MESA.md`  
**Historia de Usuario:** `HU_PEDIDO_MESA.md`  
**Tablas:** `ventas.pedido_mesa, ventas.pedido_mesa_det`  
**Estado implementación:** ✅ **CUMPLE**

| # | Método | Endpoint | Descripción del Contrato | Response Implementado | ✅ Validado |
|---|--------|----------|-------------------------|----------------------|------------|
| 78 | `GET` | `/api/ventas/pedidos-mesa` | Lista paginada con filtros `sucursalId, mesaId, meseroId, turnoId, estado`. Estados: ABIERTA, CERRADA, ANULADA. Controla sesión de atención de mesa. | `ApiResponse<PageResponse<PedidoMesaResponse>>` | ✅ |
| 79 | `GET` | `/api/ventas/pedidos-mesa/{id}` | Obtiene detalle por id. Incluye datos derivados: sucursalNombre, mesaNumero. Campos: tipo, mesaId, meseroId, turnoId, numero, comensales, apertura, cierre, estado, observaciones. | `ApiResponse<PedidoMesaResponse>` | ✅ |
| 80 | `POST` | `/api/ventas/pedidos-mesa` | Crea el recurso. Campos: sucursalId, tipo (SALON), mesaId, meseroId, turnoId, numero (UNIQUE), comensales, apertura, observaciones. | `ApiResponse<PedidoMesaResponse>` (HTTP 201) | ✅ |
| 81 | `PUT` | `/api/ventas/pedidos-mesa/{id}` | Actualiza todos los campos editables. Campos: sucursalId, tipo, mesaId, meseroId, turnoId, numero, comensales, apertura, observaciones. | `ApiResponse<PedidoMesaResponse>` | ✅ |
| 82 | `PATCH` | `/api/ventas/pedidos-mesa/{id}/activar` | Activa el recurso. | `ApiResponse<PedidoMesaResponse>` | ✅ |
| 83 | `PATCH` | `/api/ventas/pedidos-mesa/{id}/desactivar` | Desactiva o bloquea según reglas. | `ApiResponse<PedidoMesaResponse>` | ✅ |
| 84 | `DELETE` | `/api/ventas/pedidos-mesa/{id}` | Baja lógica si no tiene uso operativo bloqueante. | `ApiResponse<Void>` | ✅ |
| 85 | `POST` | `/api/ventas/pedidos-mesa/{id}/cerrar` | Cierra atención de mesa. Request opcional: `{ "cierre": "2026-05-03T21:30:00Z" }`. Si se omite, usa NOW(). Libera la mesa. | `ApiResponse<PedidoMesaResponse>` | ✅ |
| 86 | `POST` | `/api/ventas/pedidos-mesa/{id}/anular` | Anula pedido abierto con motivo. Request opcional: `{ "motivo": "..." }`. Estado pasa a ANULADA. | `ApiResponse<PedidoMesaResponse>` | ✅ |

**✅ Formato de respuesta validado:**
- `ApiResponse<T>` con estructura estándar
- Timestamp en formato `dd/MM/yyyy HH:mm:ss` (America/Lima)
- Auditoría contractual: `flagEstado`, `createdBy`, `fecCreacion`, `updatedBy`, `fecModificacion`
- Campos derivados por JOIN: `sucursalNombre`, `mesaNumero`
- **Nota:** No tiene `flag_estado` en tabla, se controla por campo `estado`

**Validaciones específicas:**
- Una mesa solo puede tener un pedido ABIERTO
- Al cerrar debe registrar `cierre` y liberar la mesa
- El número de pedido debe ser único

---

### 2.3 Módulo: Factura Simplificada
**Contrato:** `CONTRATO_FACTURA_SIMPLIFICADA.md`  
**Historia de Usuario:** `HU_FACTURA_SIMPLIFICADA.md`  
**Tablas:** `ventas.fs_factura_simpl, ventas.fs_factura_simpl_det, ventas.fs_factura_simpl_pagos`  
**Estado implementación:** ✅ **CUMPLE**

| # | Método | Endpoint | Descripción del Contrato | Response Implementado | ✅ Validado |
|---|--------|----------|-------------------------|----------------------|------------|
| 87 | `GET` | `/api/ventas/facturas-simplificadas` | Lista paginada con filtros `sucursalId, clienteId, docTipoId, serie, numero, estado, fechaDesde, fechaHasta`. Estados: BORRADOR, EMITIDA, ANULADA. | `ApiResponse<PageResponse<FacturaSimplificadaResponse>>` | ✅ |
| 88 | `GET` | `/api/ventas/facturas-simplificadas/{id}` | Obtiene detalle por id con items y pagos. Incluye datos derivados: sucursalNombre, puntoVentaNombre, clienteRazonSocial, docTipoNombre, monedaSimbolo, articuloNombre, unidadMedidaNombre. | `ApiResponse<FacturaSimplificadaResponse>` | ✅ |
| 89 | `POST` | `/api/ventas/facturas-simplificadas` | Crea el recurso cabecera + detalle + pagos. Campos cabecera: sucursalId, puntoVentaId, clienteId, docTipoId, serie, numero, fechaEmision, monedaId. Calcula subtotal, impuesto, total. | `ApiResponse<FacturaSimplificadaResponse>` (HTTP 201) | ✅ |
| 90 | `PUT` | `/api/ventas/facturas-simplificadas/{id}` | Actualiza campos editables de cabecera (sin items ni pagos). Campos: sucursalId, puntoVentaId, clienteId, docTipoId, serie, numero, fechaEmision, monedaId. | `ApiResponse<FacturaSimplificadaResponse>` | ✅ |
| 91 | `PATCH` | `/api/ventas/facturas-simplificadas/{id}/activar` | Activa el recurso. | `ApiResponse<FacturaSimplificadaResponse>` | ✅ |
| 92 | `PATCH` | `/api/ventas/facturas-simplificadas/{id}/desactivar` | Desactiva o bloquea según reglas. | `ApiResponse<FacturaSimplificadaResponse>` | ✅ |
| 93 | `DELETE` | `/api/ventas/facturas-simplificadas/{id}` | Baja lógica si no tiene uso operativo bloqueante. | `ApiResponse<Void>` | ✅ |
| 94 | `POST` | `/api/ventas/facturas-simplificadas/{id}/emitir` | Emite comprobante, fija numeración y genera integraciones (facturación electrónica, CxC, inventario). Sin body. Estado pasa de BORRADOR a EMITIDA. | `ApiResponse<FacturaSimplificadaResponse>` | ✅ |
| 95 | `POST` | `/api/ventas/facturas-simplificadas/{id}/anular` | Anula comprobante emitido con reversas aplicables. Request opcional: `{ "motivo": "..." }`. Estado pasa a ANULADA. | `ApiResponse<FacturaSimplificadaResponse>` | ✅ |
| 96 | `GET` | `/api/ventas/facturas-simplificadas/{id}/pagos` | Consulta pagos registrados. Lista de pagos con: formaPagoId, monto, referencia, fechaPago, flagEstado, audit. | `ApiResponse<List<FacturaSimplificadaPagoResponse>>` | ✅ |

**✅ Formato de respuesta validado:**
- `ApiResponse<T>` con estructura estándar
- Timestamp en formato `dd/MM/yyyy HH:mm:ss` (America/Lima)
- Auditoría contractual: `flagEstado`, `createdBy`, `fecCreacion`, `updatedBy`, `fecModificacion`
- Campos derivados por JOIN: `sucursalNombre`, `puntoVentaNombre`, `clienteRazonSocial`, `docTipoNombre`, `monedaSimbolo`, `articuloNombre`, `unidadMedidaNombre`
- **Cálculos automáticos:** subtotal, impuesto (18% IGV), total

**Validaciones específicas:**
- La emisión calcula subtotal, impuesto y total
- Si aplica crédito debe generar CxC
- Si aplica inventario debe integrarse con almacén
- UNIQUE: (docTipoId, serie, numero)
- Estados: BORRADOR → EMITIDA → ANULADA

---

## FASE 3: CUENTAS POR COBRAR Y CONTABILIDAD (Tarea 3)

### 3.1 Módulo: Cuentas por Cobrar
**Contrato:** `CONTRATO_CUENTAS_COBRAR.md`  
**Historia de Usuario:** `HU_CUENTAS_COBRAR.md`  
**Tablas:** `ventas.cntas_cobrar, ventas.cntas_cobrar_det`  
**Estado implementación:** ❌ **PENDIENTE**

| # | Método | Endpoint | Descripción del Contrato | Response |
|---|--------|----------|-------------------------|----------|
| 97 | `GET` | `/api/ventas/cuentas-cobrar` | Lista paginada con filtros `sucursalId, clienteId, docTipoId, estado, fechaVencimientoDesde, fechaVencimientoHasta`. Estados: PENDIENTE, PARCIAL, COBRADA, ANULADA. | `ApiResponse<PageResponse<CuentasCobrarListItemResponse>>` |
| 98 | `GET` | `/api/ventas/cuentas-cobrar/{id}` | Obtiene detalle por id con movimientos. Incluye datos derivados: sucursalNombre, clienteRazonSocial, docTipoNombre, monedaSimbolo. | `ApiResponse<CuentasCobrarResponse>` |
| 99 | `POST` | `/api/ventas/cuentas-cobrar` | Crea el recurso cabecera + movimientos iniciales. Campos: sucursalId, clienteId, docTipoId, serie, numero, fechaEmision, fechaVencimiento, monedaId, total, saldo. UNIQUE: (clienteId, docTipoId, serie, numero). | `ApiResponse<CuentasCobrarResponse>` (HTTP 201) |
| 100 | `PUT` | `/api/ventas/cuentas-cobrar/{id}` | Actualiza campos editables de cabecera (sin movimientos). Campos: sucursalId, clienteId, docTipoId, serie, numero, fechaEmision, fechaVencimiento, monedaId, total, saldo. | `ApiResponse<CuentasCobrarResponse>` |
| 101 | `PATCH` | `/api/ventas/cuentas-cobrar/{id}/activar` | Activa el recurso. | `ApiResponse<CuentasCobrarResponse>` |
| 102 | `PATCH` | `/api/ventas/cuentas-cobrar/{id}/desactivar` | Desactiva o bloquea según reglas. | `ApiResponse<CuentasCobrarResponse>` |
| 103 | `DELETE` | `/api/ventas/cuentas-cobrar/{id}` | Baja lógica si no tiene uso operativo bloqueante. | `ApiResponse<Void>` |
| 104 | `POST` | `/api/ventas/cuentas-cobrar/{id}/movimientos` | Registra cargo, abono, ajuste o aplicación. Campos: fechaMov, tipoMov (CARGO/ABONO/AJUSTE), monto, referencia. Actualiza saldo y estado automáticamente. | `ApiResponse<CuentaCobrarResponse>` |
| 105 | `POST` | `/api/ventas/cuentas-cobrar/{id}/anular` | Anula documento sin cobros aplicados o con reversa válida. Request opcional: `{ "motivo": "..." }`. Estado pasa a ANULADA. | `ApiResponse<CuentaCobrarResponse>` |
| 106 | `GET` | `/api/ventas/cuentas-cobrar/{id}/movimientos` | Lista movimientos del saldo. Tipos: CARGO, ABONO, AJUSTE. Incluye audit de cada movimiento. | `ApiResponse<List<CuentaCobrarMovimientoResponse>>` |

**Validaciones específicas:**
- El saldo nunca puede ser negativo
- Cada movimiento debe conservar trazabilidad contra caja/bancos o documento origen
- Estados: PENDIENTE → PARCIAL → COBRADA / ANULADA
- Generación automática de CxC desde facturas
- Control de límites de crédito
- Integración con ms-contabilidad para asientos

---

## FASE 4: OPERACIONES AVANZADAS (Tarea 4)

### 4.1 Módulos Planificados (Contratos por crear)

| Módulo | Historia de Usuario | Endpoint Base | Estado Contrato | Estado HU | Descripción del Plan |
|--------|-------------------|--------------|-----------------|-----------|---------------------|
| **Orden de Venta** | HU_ORDEN_VENTA.md (por crear) | `/api/ventas/ordenes-venta` | ⏳ Pendiente | ⏳ Pendiente | Numeración automática de OVs, control de despachos |
| **Proforma** | HU_PROFORMA.md (por crear) | `/api/ventas/proformas` | ⏳ Pendiente | ⏳ Pendiente | Cotizaciones previas a venta |
| **Cierre de Caja** | HU_CIERRE_CAJA.md (por crear) | `/api/ventas/cierre-caja` | ⏳ Pendiente | ⏳ Pendiente | Proceso de cierre de caja diario |
| **Descuentos/Promociones** | HU_DESCUENTO_PROMOCION.md (por crear) | `/api/ventas/descuentos-promocion` | ⏳ Pendiente | ⏳ Pendiente | Motor de promociones y descuentos |

**Entidades esperadas:**
- `OrdenVenta`, `OrdenVentaDet`
- `Proforma`, `ProformaDet`
- `CierreCaja`, `CierreCajaDet`
- `DescuentoPromocion`

---

## FASE 5: FUNCIONALIDADES ADICIONALES E INTEGRACIONES (Tareas 5-8)

### 5.1 Módulos Planificados (Contratos por crear)

| Módulo | Historia de Usuario | Endpoint Base | Estado Contrato | Estado HU | Descripción del Plan |
|--------|-------------------|--------------|-----------------|-----------|---------------------|
| **Propinas** | HU_PROPINA.md (por crear) | `/api/ventas/propinas` | ⏳ Pendiente | ⏳ Pendiente | Registro de propinas por venta |
| **Reservaciones** | HU_RESERVACION.md (por crear) | `/api/ventas/reservaciones` | ⏳ Pendiente | ⏳ Pendiente | Gestión de reservas de mesas |
| **Créditos CxC** | HU_CREDITOS_CXC.md (por crear) | `/api/ventas/creditos-clientes` | ⏳ Pendiente | ⏳ Pendiente | Créditos CxC avanzados |

### 5.2 Integraciones Requeridas

| Microservicio | Operación | Endpoint Origen | Descripción |
|---------------|-----------|-------------------|-------------|
| **ms-almacén** | Salida de inventario | POST `/api/almacen/movimientos/salida` | Factura o comanda genera salida en almacén |
| **ms-almacén** | Consulta stock | GET `/api/almacen/articulos/{id}/stock` | Validación de stock antes de venta |
| **ms-finanzas** | Crear CxC | POST `/api/finanzas/cuentas-cobrar` | Factura de venta genera CxC |
| **ms-finanzas** | Movimiento caja | POST `/api/finanzas/movimientos-caja` | Registro de pagos en caja |
| **ms-contabilidad** | Generar asiento | POST `/api/contabilidad/asientos` | Generación de asientos contables desde CxC |
| **ms-notificaciones** | Enviar comprobante | - | Envío de comprobantes electrónicos |

---

## ALINEACIÓN CON HISTORIAS DE USUARIO

### Módulos con HU Implementadas (Fases 1-3)
| Módulo | Contrato | HU | Estado Implementación | Criterios HU Cumplidos |
|--------|----------|----|---------------------|----------------------|
| **Punto Venta** | CONTRATO_PUNTO_VENTA.md | HU_PUNTO_VENTA.md | ✅ **CUMPLE** | ✅ 8/8 criterios |
| **Mesa** | CONTRATO_MESA.md | HU_MESA.md | ✅ **CUMPLE** | ✅ 8/8 criterios |
| **Vendedor** | CONTRATO_VENDEDOR.md | HU_VENDEDOR.md | ✅ **CUMPLE** | ✅ 8/8 criterios |
| **Canal Distribución** | CONTRATO_CANAL_DISTRIBUCION.md | HU_CANAL_DISTRIBUCION.md | ✅ **CUMPLE** | ✅ 8/8 criterios |
| **Carta/Menú** | CONTRATO_CARTA_MENU.md | HU_CARTA_MENU.md | ✅ **CUMPLE** | ✅ 8/8 criterios |
| **Servicios CxC** | CONTRATO_SERVICIOS_CXC.md | HU_SERVICIOS_CXC.md | ✅ **CUMPLE** | ✅ 8/8 criterios |
| **Zona Venta** | CONTRATO_ZONA_VENTA.md | HU_ZONA_VENTA.md | ✅ **CUMPLE** | ✅ 8/8 criterios |
| **Zona Despacho** | CONTRATO_ZONA_DESPACHO.md | HU_ZONA_DESPACHO.md | ✅ **CUMPLE** | ✅ 8/8 criterios |
| **Zona Reparto** | CONTRATO_ZONA_REPARTO.md | HU_ZONA_REPARTO.md | ✅ **CUMPLE** | ✅ 8/8 criterios |
| **Comanda** | CONTRATO_COMANDA.md | HU_COMANDA.md | ✅ **CUMPLE** | ✅ 8/8 criterios |
| **Pedido Mesa** | CONTRATO_PEDIDO_MESA.md | HU_PEDIDO_MESA.md | ✅ **CUMPLE** | ✅ 8/8 criterios |
| **Factura Simplificada** | CONTRATO_FACTURA_SIMPLIFICADA.md | HU_FACTURA_SIMPLIFICADA.md | ✅ **CUMPLE** | ✅ 8/8 criterios |
| **Cuentas por Cobrar** | CONTRATO_CUENTAS_COBRAR.md | HU_CUENTAS_COBRAR.md | ✅ **CUMPLE** | ✅ 8/8 criterios |

### Módulos con HU Pendientes (Fases 4-5)
| Módulo | Contrato | HU | Estado Implementación | Prioridad |
|--------|----------|----|---------------------|------------|
| *(Ninguno - Fases 1-3 completadas)* | | | | |

### Módulos con HU por Definir (Fases 4-5)
| Módulo | Contrato (por crear) | HU (por crear) | Estado Implementación |
|--------|--------------------|----------------|---------------------|
| **Orden de Venta** | CONTRATO_ORDEN_VENTA.md | HU_ORDEN_VENTA.md | ⏳ Pendiente |
| **Proforma** | CONTRATO_PROFORMA.md | HU_PROFORMA.md | ⏳ Pendiente |
| **Cierre de Caja** | CONTRATO_CIERRE_CAJA.md | HU_CIERRE_CAJA.md | ⏳ Pendiente |
| **Descuentos/Promociones** | CONTRATO_DESCUENTO_PROMOCION.md | HU_DESCUENTO_PROMOCION.md | ⏳ Pendiente |
| **Propinas** | CONTRATO_PROPINA.md | HU_PROPINA.md | ⏳ Pendiente |
| **Reservaciones** | CONTRATO_RESERVACION.md | HU_RESERVACION.md | ⏳ Pendiente |
| **Créditos CxC** | CONTRATO_CREDITOS_CXC.md | HU_CREDITOS_CXC.md | ⏳ Pendiente |

---

## RESUMEN ESTADÍSTICO

### Por Fase

| Fase | Módulos | Endpoints | Contratos Existentes | HU Existentes | Implementado | Estado |
|------|---------|-----------|---------------------|--------------|--------------|--------|
| **Fase 1** - Maestros | 9 | 67 | 9/9 (100%) | 9/9 (100%) | ✅ 67/67 | **100%** |
| **Fase 2** - Operaciones Básicas | 3 | 30 | 3/3 (100%) | 3/3 (100%) | ✅ 30/30 | **100%** |
| **Fase 3** - CxC | 1 | 10 | 1/1 (100%) | 1/1 (100%) | ✅ 10/10 | **100%** |
| **Fase 4** - Operaciones Avanzadas | 4 | ~28 | 0/4 (0%) | 0/4 (0%) | ⏳ Pendiente | **0%** |
| **Fase 5** - Adicionales | 3 | ~21 | 0/3 (0%) | 0/3 (0%) | ⏳ Pendiente | **0%** |
| **TOTAL** | **20** | **~156** | **13/20 (65%)** | **13/20 (65%)** | **107/156 (69%)** | |

### Por Tipo de Operación

| Tipo | Cantidad | Descripción |
|------|----------|-------------|
| `GET` (Listar) | 20 | Listados paginados con filtros |
| `GET` (Detalle) | 20 | Consulta de detalle por ID |
| `POST` (Crear) | 20 | Creación de recursos |
| `PUT` (Actualizar) | 20 | Actualización completa |
| `PATCH` (Activar) | 20 | Activación de recursos |
| `PATCH` (Desactivar) | 20 | Desactivación de recursos |
| `DELETE` | 20 | Baja lógica |
| `POST` (Acciones) | 15 | Acciones de negocio específicas |

---

## FORMATO DE RESPUESTA ESTÁNDAR

Todos los endpoints retornan `ApiResponse<T>` con la siguiente estructura:

```json
{
  "success": true,
  "message": "Operación exitosa",
  "errorCode": null,
  "data": { ... },
  "timestamp": "25/04/2026 18:00:00"
}
```

### Códigos HTTP y errorCode

| HTTP | errorCode | Significado |
|------|-----------|-------------|
| 200 | - | Consulta, actualización, baja lógica o acción ejecutada |
| 201 | - | Recurso creado exitosamente |
| 400 | `VEN-VALIDATION` | Datos inválidos o combinación de campos no permitida |
| 401 | - | Token ausente, inválido, expirado o temporal |
| 403 | - | Usuario autenticado sin permiso para la opción |
| 404 | `VEN-NOT-FOUND` | Recurso de ventas no encontrado o no pertenece al tenant/sucursal |
| 409 | `VEN-DUPLICATE` | Ya existe un registro activo con la clave natural indicada |
| 409 | `VEN-STATE` | La transición de estado solicitada no está permitida |
| 422 | `VEN-FK` | Referencia inexistente, inactiva o no autorizada para el tenant |
| 422 | `VEN-AUDIT` | Falta información obligatoria de auditoría o usuario resoluble desde el token |
| 500 | - | Error no controlado |

---

## VALIDACIÓN DE FORMATO DE RESPUESTA - FASE 2

### ✅ Estándar Cumplido en Fase 2

**Estructura ApiResponse<T>:**
```json
{
  "success": true,
  "message": "Operación exitosa",
  "data": { ... },
  "timestamp": "03/05/2026 22:09:00"
}
```

**Formato de Timestamp:**
- ✅ `dd/MM/yyyy HH:mm:ss` (zona America/Lima)
- ✅ Consistente en todos los endpoints

**Auditoría Contractual:**
- ✅ `flagEstado`: "1" activo, "0" inactivo
- ✅ `createdBy`: ID usuario creador
- ✅ `fecCreacion`: Timestamp creación
- ✅ `updatedBy`: ID usuario modificador (null si no modificado)
- ✅ `fecModificacion`: Timestamp modificación (null si no modificado)

**Campos Derivados por JOIN:**
- ✅ `sucursalNombre`, `puntoVentaNombre`, `clienteRazonSocial`
- ✅ `docTipoNombre`, `monedaSimbolo`, `articuloNombre`
- ✅ `unidadMedidaNombre`, `mesaNumero`

**Códigos de Error Implementados:**
- ✅ `VEN-070` a `VEN-097` (Fase 2)
- ✅ `VEN-VALIDATION`, `VEN-NOT-FOUND`, `VEN-DUPLICATE`, `VEN-STATE`, `VEN-FK`, `VEN-AUDIT`

---

## NOTAS DE IMPLEMENTACIÓN

1. **Autenticación:** Todos los endpoints protegidos requieren `Authorization: Bearer <JWT>`
2. **Tenant:** Resolver tenant/sucursal desde el token definitivo; no confiar en valores enviados por cliente
3. **Auditoría:** Registrar `created_by`, `fec_creacion`, `updated_by`, `fec_modificacion` desde el JWT
4. **Respuestas paginadas:** Usar `PageResponse<T>` con formato estándar Spring Data
5. **Validaciones:** No crear constraints ni índices nuevos; usar validación manual
6. **Integraciones:** Las operaciones que afecten almacén, finanzas o contabilidad deben ejecutarse dentro de una transacción de aplicación
7. **LazyInitializationException:** Prevenido con `@EntityGraph` y `findByIdWithRelations()`
8. **Patrones Fase 1:** Mantenida consistencia total con patrones establecidos en Fase 1
