# ms-ventas — Procesos operativos y administrativos

Este documento describe los **flujos que atraviesan varios pasos** (POS, cobranzas, demo) y cómo se exponen por HTTP. Complementa [`FLUJO_COMPLETO_MS_VENTAS.md`](./FLUJO_COMPLETO_MS_VENTAS.md) y la lista de rutas en [`RESUMEN_LOGICA_Y_ENDPOINTS.md`](./RESUMEN_LOGICA_Y_ENDPOINTS.md).

---

## Arquitectura elegida

- Los procesos de negocio se implementan como **endpoints REST** en los controladores correspondientes (`ComandaController`, `PedidoMesaController`, `FacturaSimplificadaController`, `CuentaCobrarController`, etc.).
- La ejecución es **sincrónica y transaccional** por petición (patrón alineado con `ms-almacen` para procesos por menú).
- No hay cola ni job programado en esta etapa para estos flujos; pueden evolucionar a asíncronos si el volumen o SLA lo exigen.

---

## Proceso POS: comanda → pedido mesa → factura simplificada

Orden típico en restaurante (puede variar según pantalla; aquí el orden lógico de datos):

| Paso | Endpoint principal | Notas |
|------|-------------------|--------|
| 1. Comanda cocina/barra | `POST /api/ventas/comandas` | Creación en estado operativo inicial. |
| 2. Ítems a la comanda | `POST /api/ventas/comandas/{id}/items` | Solo si la comanda está en estado editable según reglas de servicio. |
| 3. Estado comanda | `PATCH /api/ventas/comandas/{id}/estado` | Transiciones operativas (cocina/barra). |
| 4. Sesión mesa | `POST /api/ventas/pedidos-mesa` | Vincula mesa/turno/mesero según request. |
| 5. Cierre pedido mesa | `POST /api/ventas/pedidos-mesa/{id}/cerrar` | Cierra la sesión de atención. |
| 6. Factura borrador | `POST /api/ventas/facturas-simplificadas` | Registro previo a emisión. |
| 7. Emisión | `POST /api/ventas/facturas-simplificadas/{id}/emitir` | Pasa a emitido según reglas de negocio. |
| 8. Pagos consulta | `GET /api/ventas/facturas-simplificadas/{id}/pagos` | Lista pagos asociados cuando aplique. |

Anulaciones puntuales:

- Comanda: `POST /api/ventas/comandas/{id}/anular`
- Pedido mesa: `POST /api/ventas/pedidos-mesa/{id}/anular`
- Factura: `POST /api/ventas/facturas-simplificadas/{id}/anular`

---

## Proceso CxC + contabilidad

| Paso | Endpoint / llamada | Notas |
|------|---------------------|--------|
| 1. Alta cuenta | `POST /api/ventas/cuentas-cobrar` | Persiste `cntas_cobrar` + movimientos iniciales en `cntas_cobrar_det` cuando vienen en el body. |
| 2. Saldo y estado | Lógica en `CuentaCobrarService` | Deriva PENDIENTE / PARCIAL / COBRADA / ANULADA según movimientos y saldo. |
| 3. Asiento contable | Feign → `POST .../api/contabilidad/asientos/generar/registro-cntas-cobrar` | Solo cuando corresponde y `cntbl_asiento_id` aún es nulo; respetar configuración y disponibilidad de `ms-contabilidad`. |
| 4. Vínculo | Actualización de cabecera | Se guarda `cntbl_asiento_id` en `ventas.cntas_cobrar`. |

Movimientos posteriores y anulación:

- `POST /api/ventas/cuentas-cobrar/{id}/movimientos`
- `POST /api/ventas/cuentas-cobrar/{id}/anular`

---

## Proceso: orden de venta, proforma, cierre de caja y promociones (Fase 4)

Referencia de rutas y orquestación: [`../../05. Documentacion/orquestacion/ORQUESTACION_MS-VENTAS.md`](../../05.%20Documentacion/orquestacion/ORQUESTACION_MS-VENTAS.md).

| Área | Ideas clave |
|------|-------------|
| OV | `POST/PUT` + `PATCH` confirmar/anular/cerrar; número automático con **`NumeradorDocumentoService`** si `nroOrdenVenta` vacío. |
| Proforma | Listado sin líneas (`detalles` null); detalle en `GET/{id}`; número automático con numerador si `numero` vacío (**`sucursalId` obligatoria**). |
| Cierre caja | Apertura `POST`, cierre `PATCH .../cerrar`; lectura con `estadoCierre` OPEN/CLOSED cuando aplique. |
| Promociones | CRUD + activar/desactivar; vigencia derivada en lectura. |

---

## Proceso administrativo: seed de datos demo

**Solo entornos controlados.** En **ms-ventas** la ruta **siempre existe**; si el seed está desactivado, la respuesta es **403** `TESTDATA_DISABLED` (no 404).

- Propiedad: `app.testdata.enabled` — en `application.yml` por defecto **`${APP_TESTDATA_ENABLED:true}`** (habilitado salvo override). En **producción** usar **`APP_TESTDATA_ENABLED=false`** (o `app.testdata.enabled=false`).
- Endpoint: `POST /api/ventas/admin/test-data/seed`
- Comportamiento: ejecuta `TestDataSeedService.seedVentasDemoData()` — **relleno masivo orientado a demo** (incluye borrados/inserts según implementación del servicio).

Para pruebas automatizadas **idempotentes** sin masacrar datos, usar `VentasTestDataFactory` (ver [`docs/test-data-y-pruebas.md`](./docs/test-data-y-pruebas.md)).

---

## Roadmap issue 5 — propinas, reservaciones, créditos CxC e integración factura

| Tema | Dónde se detalla |
|------|------------------|
| APIs `/propinas`, `/reservaciones`, `/creditos-cxc` (contratos; código pendiente) | [`RESUMEN_LOGICA_Y_ENDPOINTS.md`](./RESUMEN_LOGICA_Y_ENDPOINTS.md) §E; contratos en `05. Documentacion/markdown/Contratos/ms-ventas/` |
| Factura emitida → salida almacén / CxC finanzas (planificado) | [`../../05. Documentacion/orquestacion/ORQUESTACION_MS-VENTAS.md`](../../05.%20Documentacion/orquestacion/ORQUESTACION_MS-VENTAS.md) **§14** |

---

## Logs y observabilidad

- Los servicios siguen el patrón del proyecto: transacciones en capa `@Service`, errores de negocio como `BusinessException` con códigos (`VEN-*`, etc.).
- Fallos al llamar a contabilidad vía Feign deben quedar reflejados en logs de aplicación y en respuesta HTTP según el manejo actual (`SERVICE_UNAVAILABLE` / mensajes de negocio).

---

## Documentación relacionada

- Datos de prueba (factory vs seed): [`docs/test-data-y-pruebas.md`](./docs/test-data-y-pruebas.md)
- Contratos oficiales: `05. Documentacion/markdown/Contratos/ms-ventas/`
