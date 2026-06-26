# Auditoría: Endpoints vs Contratos vs DDL

> **Documento:** Contraste exhaustivo entre código implementado (23 controllers), contratos técnicos (21 archivos), orquestación, y esquema DDL  
> **Fecha generación:** 29/05/2026  
> **Responsable:** Dev ms-ventas  
> **Alcance:** 131 endpoints en código vs ~155 endpoints contratados vs esquema `ventas.*`  
> **Fuentes contrastadas:**  
> - Código fuente: `ms-ventas/src/main/java/pe/restaurant/ventas/controller/` (23 controllers)
> - Contratos: `05. Documentacion/markdown/Contratos/ms-ventas/` (21 archivos)
> - Orquestación: `05. Documentacion/orquestacion/ORQUESTACION_MS-VENTAS.md`
> - DDL: `03. Base de datos/ddl/tenant/04-ventas.sql`
> - HUs: `05. Documentacion/HUs por modulo/03_Ventas/`

---

## 1. RESUMEN EJECUTIVO

| Métrica | Valor |
|---|---|
| Controllers en código | **23** |
| Endpoints implementados | **131** |
| Endpoints en contratos | **~155** |
| Endpoints en orquestación | **~170** |
| En código pero NO en contratos | **13** (deuda documental) |
| En contratos pero NO en código | **1** (`mesas/estado/{estado}`) |
| Contratos que describen algo que NO existe en BD | **1** (Mesa: campo `estado` no existe en DDL) |
| Controllers sin contrato asociado | **1** (ZonaController — `zonas` de salón) |
| Legacy documentado sin implementar | **~26** (arquitectura, posiblemente deprecado) |

---

## 2. MAPEO COMPLETO: Controller vs Contrato vs DDL

### 2.1 FASE 1 — Maestros

| # | Controller | Base path | Endpoints código | Endpoints contrato | DDL ok | Brecha |
|---|---|---|---|---|---|---|
| 1 | PuntoVentaController | `/api/ventas/puntos-venta` | 8 | 7 | ✅ | +1 extra: `GET /sucursal/{sucursalId}` |
| 2 | MesaController | `/api/ventas/mesas` | 9 | 7 | ⚠️ | +2 extras: `GET /zona/{zonaId}`, `GET /sucursal/{sucursalId}`. Contrato menciona columna `estado` que NO existe en DDL |
| 3 | VendedorController | `/api/ventas/vendedores` | 8 | 7 | ✅ | +1 extra: `GET /usuario/{usuarioId}` |
| 4 | CanalDistribucionController | `/api/ventas/canales-distribucion` | 7 | 7 | ✅ | Sin brecha |
| 5 | CartaController + CartaItemController | `/api/ventas/cartas` | 11 | 11 | ✅ | Sin brecha |
| 6 | ServiciosCxCController | `/api/ventas/servicios-cxc` | 7 | 7 | ✅ | Sin brecha |
| 7 | ZonaVentaController | `/api/ventas/zonas-venta` | 7 | 7 | ✅ | Sin brecha |
| 8 | ZonaDespachoController | `/api/ventas/zonas-despacho` | 7 | 7 | ✅ | Sin brecha |
| 9 | ZonaRepartoController | `/api/ventas/zonas-reparto` | 7 | 7 | ✅ | Sin brecha |
| 10 | **ZonaController** | **`/api/ventas/zonas`** | **9** | **—** | ✅ | **SIN CONTRATO. Zonas de salón existen en código pero no hay contrato asociado** |

### 2.2 FASE 2 — Operaciones

| # | Controller | Base path | Endpoints código | Endpoints contrato | DDL ok | Brecha |
|---|---|---|---|---|---|---|
| 11 | ComandaController | `/api/ventas/comandas` | 10 | 10 | ✅ | Sin brecha |
| 12 | PedidoMesaController | `/api/ventas/pedidos-mesa` | 10 | 10 | ✅ | Sin brecha |
| 13 | FacturaSimplificadaController | `/api/ventas/facturas-simplificadas` | 10 | 10 | ✅ | Sin brecha |

### 2.3 FASE 3 — Financiero

| # | Controller | Base path | Endpoints código | Endpoints contrato | DDL ok | Brecha |
|---|---|---|---|---|---|---|
| 14 | CuentaCobrarController | `/api/ventas/cuentas-cobrar` | **15** | 10 | ✅ | +5 extras: `directo`, `detraccion`, `notas-credito`, `pendientes/agrupado`, `pendientes/simple` |

### 2.4 FASE 4 — Transaccionales pendientes de contrato original

| # | Controller | Base path | Endpoints código | Endpoints contrato | DDL ok | Brecha |
|---|---|---|---|---|---|---|
| 15 | OrdenVentaController | `/api/ventas/ordenes-venta` | **8** | 7 | ✅ | +1 extra: `POST /{id}/despachar` |
| 16 | ProformaController | `/api/ventas/proformas` | 7 | 7 | ✅ | Sin brecha |
| 17 | CierreCajaController | `/api/ventas/cierre-caja` | 4 | 4 | ✅ | Sin brecha |
| 18 | DescuentoPromocionController | `/api/ventas/descuentos-promocion` | 7 | 7 | ✅ | Sin brecha |
| 19 | PropinaController | `/api/ventas/propinas` | 6 | 6 | ✅ | Sin brecha |
| 20 | ReservacionController | `/api/ventas/reservaciones` | 8 | 8 | ✅ | Sin brecha |
| 21 | EntidadCreditosCxcController | `/api/ventas/creditos-cxc` | 7 | 7 | ✅ | Sin brecha |

### 2.5 Admin

| # | Controller | Base path | Endpoints código | Contrato | DDL ok | Brecha |
|---|---|---|---|---|---|---|
| 22 | TestDataAdminController | `/api/ventas/admin/test-data` | 1 | — | N/A | Admin, no aplica contrato |

---

## 3. HALLAZGOS

### 🔴 H-01: Columna `estado` en Mesa — Contrato vs DDL

**Severidad:** ALTA  
**Origen:** Contrato MESA + HU_MESA + VERIFICACION_CONTRATO_VS_IMPLEMENTACION  
**Descripción:** El contrato y la HU documentan que `ventas.mesa` tiene un campo `estado` con valores `LIBRE, OCUPADA, RESERVADA, BLOQUEADA`, y que el GET list permite filtrar por `estado`. Sin embargo:

- La DDL (`04-ventas.sql:220-232`) **no tiene columna `estado`** en `ventas.mesa`
- El endpoint `GET /api/ventas/mesas?estado=X` **no existe** en código
- El endpoint `GET /api/ventas/mesas/estado/{estado}` documentado en orquestación **no existe**
- Los documentos de verificación existentes marcan esto como "✅ Implementados", lo cual es **incorrecto**
- El `estado` de una mesa se infiere consultando `pedido_mesa` (si tiene un pedido abierto → OCUPADA), pero no hay lógica implementada para esto

**Impacto:** El frontend que consuma estos endpoints no va a encontrar el filtro ni la columna. QA no puede probar flujos que dependan del estado de mesa.

**Posibles soluciones:**
1. Agregar columna `estado` a `ventas.mesa` + migración de datos + endpoints
2. Implementar estado derivado vía subquery a `pedido_mesa` (estado virtual, sin columna)
3. Eliminar la mención de `estado` del contrato si no es requerimiento real

---

### 🟡 H-02: Endpoints en código sin documentación en contratos (13)

**Severidad:** MEDIA  
**Descripción:** Estos endpoints existen funcionales pero no están en ningún contrato. Riesgo de que se pierdan en refactors o que QA no los considere en pruebas.

| Controller | Endpoint faltante en contrato |
|---|---|
| MesaController | `GET /api/ventas/mesas/zona/{zonaId}` |
| MesaController | `GET /api/ventas/mesas/sucursal/{sucursalId}` |
| PuntoVentaController | `GET /api/ventas/puntos-venta/sucursal/{sucursalId}` |
| VendedorController | `GET /api/ventas/vendedores/usuario/{usuarioId}` |
| CartaController | `GET /api/ventas/cartas/sucursal/{sucursalId}` |
| CuentaCobrarController | `POST /api/ventas/cuentas-cobrar/directo` |
| CuentaCobrarController | `POST /api/ventas/cuentas-cobrar/{id}/detraccion` |
| CuentaCobrarController | `POST /api/ventas/cuentas-cobrar/notas-credito` |
| CuentaCobrarController | `GET /api/ventas/cuentas-cobrar/pendientes/agrupado` |
| CuentaCobrarController | `GET /api/ventas/cuentas-cobrar/pendientes/simple` |
| OrdenVentaController | `POST /api/ventas/ordenes-venta/{id}/despachar` |
| ZonaController | 9 endpoints completos (todo el controller) |

**Acción requerida:** Actualizar los contratos para incluirlos, o decidir si algunos deben deprecarse.

---

### 🟡 H-03: ZonaController sin contrato

**Severidad:** MEDIA  
**Descripción:** El controller `ZonaController` (`/api/ventas/zonas`) tiene 9 endpoints completamente implementados (CRUD + sucursal + activas + delete) pero no existe ni contrato ni HU asociada. Es un endpoint "huérfano" documentalmente.

**Acción requerida:** Crear `CONTRATO_ZONA.md` y `HU_ZONA.md`, o fusionarlo con la documentación de Mesa si corresponde.

---

### 🟢 H-04: Reportes y facturación electrónica sin implementar

**Severidad:** BAJA (alcance no definido)  
**Descripción:** La documentación legacy (`ARQUITECTURA_RESTAURANT_PE.md`) lista ~26 endpoints que nunca se construyeron. Incluye:

- `/api/ventas/reportes/*` (ventas diarias, por artículo, por mesero, cierre caja, propinas)
- `/api/ventas/facturacion-electronica/*` (enviar, estado, cdr)
- `/api/ventas/documentos/*`
- `/api/ventas/notas-credito`, `/api/ventas/notas-debito`
- `/api/ventas/ordenes/*` (ruta legacy), dividir-cuenta, unir-mesas
- `/api/ventas/recargos-consumo`
- `/api/ventas/cierres-caja/abrir`, `arqueo`

**Acción requerida:** Depurar la documentación legacy. Si son requerimiento futuro, crear HUs y contratos formales.

---

### 🟢 H-05: Integraciones inter-servicio pendientes

**Severidad:** BAJA (dependencias externas)  
**Descripción:** Según el documento de FALTANTES, hay 2 integraciones pendientes:

1. Factura simplificada → ms-almacen (salida automática de inventario)
2. Factura simplificada → ms-finanzas (generación automática de CxC)

Ya existe `POST /ordenes-venta/{id}/despachar` que integra con ms-almacen, pero el circuito de factura simplificada no está conectado.

---

## 4. DETALLE POR RECURSO

### 4.1 Mesa — Inconsistencias documentales

| Fuente | Dice | Realidad |
|---|---|---|
| Contrato MESA: GET list | Filtro `estado` disponible | No existe en repository |
| Contrato MESA: detalle | Response con `estado` | Entity no tiene campo `estado` |
| Contrato MESA: POST | Campo `estado` en body | No se recibe ni persiste |
| HU_MESA | "controlar disponibilidad operativa" | No hay lógica de disponibilidad |
| `VERIFICACION_CONTRATO_VS_IMPLEMENTACION.md` | ✅ Estado implementado, filtro OK | ❌ Falso positivo |
| DDL `ventas.mesa` | Solo `flag_estado` (1/0), sin `estado` | Coincide con código |
| `endpoints-por-contrato.md` | #8: GET lista con filtro `estado` | No existe |
| `endpoints-por-contrato.md` | #48-49: solo 7 endpoints | Código tiene 9 |

### 4.2 CuentaCobrar — Endpoints extra

El contrato CxC documenta 10 endpoints. El código tiene 15. Los 5 adicionales son funcionalidades operativas clave:

| Endpoint extra | Función |
|---|---|
| `POST /cuentas-cobrar/directo` | Ingresos fuera de venta POS/OV |
| `POST /cuentas-cobrar/{id}/detraccion` | Detracción vinculada (>= S/ 700) |
| `POST /cuentas-cobrar/notas-credito` | Nota de crédito por cobrar (NCC) |
| `GET /cuentas-cobrar/pendientes/agrupado` | Pendientes agrupados con totales |
| `GET /cuentas-cobrar/pendientes/simple` | Pendientes en formato unificado |

### 4.3 OrdenVenta — Endpoint extra

| Endpoint extra | Función |
|---|---|
| `POST /ordenes-venta/{id}/despachar` | Despacha OV → genera salida en ms-almacen |

### 4.4 Carta — Endpoint extra

| Endpoint extra | Función |
|---|---|
| `GET /cartas/sucursal/{sucursalId}` | Cartas activas por sucursal |

---

## 5. COMPARATIVA CON DOCUMENTOS EXISTENTES

### 5.1 `endpoints-por-contrato.md`

| Recurso | Endpoints listados | Endpoints reales en código | Diferencia |
|---|---|---|---|
| PuntoVenta | 7 | 8 | +1 sucursal |
| Mesa | 7 | 9 | +2 zona/sucursal |
| Vendedor | 7 | 8 | +1 usuario |
| Carta | 11 | 11 | ✅ |
| CanalDistribucion | 7 | 7 | ✅ |
| ServiciosCxC | 7 | 7 | ✅ |
| ZonaVenta/Despacho/Reparto | 7 c/u | 7 c/u | ✅ |
| Comanda | 10 | 10 | ✅ |
| FacturaSimplificada | 10 | 10 | ✅ |
| PedidoMesa | 10 | 10 | ✅ |
| CuentasCobrar | 10 | 15 | +5 |
| OrdenVenta | 7 | 8 | +1 despachar |
| Proforma | 7 | 7 | ✅ |
| CierreCaja | 4 | 4 | ✅ |
| DescuentoPromocion | 7 | 7 | ✅ |
| Propina | 6 | 6 | ✅ |
| Reservacion | 8 | 8 | ✅ |
| CreditosCxc | 7 | 7 | ✅ |

### 5.2 `VERIFICACION_CONTRATO_VS_IMPLEMENTACION.md`

Este documento contiene **falsos positivos** en la sección Mesa:

| Aspecto | Dice | Realidad |
|---|---|---|
| Filtros GET | ✅ Implementados | Filtro `estado` no existe |
| Estados | ✅ Implementados | No hay columna `estado` en DDL |
| Validación OCUPADA | ✅ `MESA_OCUPADA_NO_DESACTIVABLE` | No hay lógica de estados, no se valida ocupación |

Además, no cubre: OrdenVenta, Proforma, CierreCaja, DescuentoPromocion, Propina, Reservacion, CreditosCxc (que según el documento de FALTANTES ya están implementados en Fase 4).

### 5.3 `faltante_20260502_ms_ventas.md`

Reporta 69% de avance y listas Fase 1/2/3 al 100%. No incluye Fase 4 (OV, proforma, cierre caja, descuentos, propinas, reservaciones, créditos CxC). Desactualizado.

---

## 6. RECOMENDACIONES

### Inmediatas (QA / Dev)

1. **Definir el modelo de estado de Mesa** — Decidir si se agrega columna a DDL o se implementa estado derivado vía `pedido_mesa`. Sin esto, los endpoints de mesa por estado no se pueden construir.
2. **Corregir `VERIFICACION_CONTRATO_VS_IMPLEMENTACION.md`** — Marcar Mesa como ⚠️ parcial en lugar de ✅. Incluir Fase 4.
3. **Actualizar `faltante_20260502_ms_ventas.md`** — Reflejar el estado real post implementación de Fase 4.

### Corto plazo

4. **Agregar los 13 endpoints faltantes a los contratos respectivos** (o deprecar los que no correspondan).
5. **Crear contrato para ZonaController** (`CONTRATO_ZONA.md` + HU).
6. **Depurar `ARQUITECTURA_RESTAURANT_PE.md`** — Mover los ~26 endpoints legacy a un anexo de "futuros" o eliminarlos.

### Mediano plazo

7. **Integración factura simplificada → almacén/finanzas** (issue 5 de FALTANTES).
8. **Evaluar si las HUs de regalías y reporte tributario requieren nuevos endpoints REST o van por otra vía.**

---

## 7. ANEXO: Endpoints legacy sin implementar (ARQUITECTURA_RESTAURANT_PE.md)

Endpoint legacy | Método | Posible reemplazo
|---|---|---|
| `/api/ventas/documentos` | GET, GET/{id}, POST, POST/{id}/anular | — |
| `/api/ventas/notas-credito` | POST | Parcial: `POST /cuentas-cobrar/notas-credito` |
| `/api/ventas/notas-debito` | POST | — |
| `/api/ventas/ordenes` (ruta legacy) | GET, GET/{id}, POST, POST/{id}/cerrar | `/api/ventas/ordenes-venta/*` |
| `/api/ventas/ordenes/{id}/comandas` | POST, PUT, DELETE | — |
| `/api/ventas/ordenes/{id}/dividir-cuenta` | POST | — |
| `/api/ventas/ordenes/{id}/unir-mesas` | POST | — |
| `/api/ventas/recargos-consumo` | GET | — |
| `/api/ventas/facturacion-electronica/enviar/{id}` | POST | — |
| `/api/ventas/facturacion-electronica/estado/{id}` | GET | — |
| `/api/ventas/facturacion-electronica/cdr/{id}` | GET | — |
| `/api/ventas/reportes/ventas-diarias` | GET | — |
| `/api/ventas/reportes/ventas-por-articulo` | GET | — |
| `/api/ventas/reportes/ventas-por-mesero` | GET | — |
| `/api/ventas/reportes/cierre-caja-resumen` | GET | — |
| `/api/ventas/reportes/propinas-periodo` | GET | — |
| `/api/ventas/cierres-caja/abrir` | POST | — |
| `/api/ventas/cierres-caja/{id}/arqueo` | GET | — |
