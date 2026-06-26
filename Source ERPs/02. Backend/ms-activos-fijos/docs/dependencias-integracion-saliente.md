# Integración saliente — `ms-activos-fijos`

Contratos consumidos **desde este microservicio** (sin cambiar el código de los otros MS).

**Contrato API expuesto:** `05. Documentacion/markdown/Contratos/ms-activos-fijos/CONTRATO_AF_INTEGRACION.md`  
**Orquestación:** `05. Documentacion/orquestacion/ORQUESTACION_MS-ACTIVOS-FIJOS.md` §16–§17.

## Clientes Feign (`pe.restaurant.activos.client`)

| Cliente | Servicio | Uso |
|---------|----------|-----|
| `CoreMaestrosClient` | `ms-core-maestros` | Validación de sucursal y entidad contribuyente. |
| `ContabilidadAsientosClient` | `ms-contabilidad` | `GET /{id}`, `GET /buscar`, `POST` crear asiento. |
| `ComprasActivosClient` | `ms-compras` | `GET /api/compras/ordenes-compra/{id}`; recepciones asociadas a OC. |

## API de integración (este MS)

| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/api/activos/integracion/contabilidad/depreciacion/{calculoId}` | Asiento gasto / dep. acumulada. |
| POST | `/api/activos/integracion/contabilidad/devengo/{devengoId}` | Asiento devengo de prima. |
| POST | `/api/activos/integracion/contabilidad/venta/{ventaId}` | Asiento baja/venta. |
| POST | `/api/activos/integracion/contabilidad/valuacion/{valuacionId}` | Asiento revaluación. |
| POST | `/api/activos/integracion/contabilidad/alta/{maestroId}` | Asiento alta de activo. |
| POST | `/api/activos/integracion/contabilidad/adaptacion/{adaptacionId}` | Asiento capitalización. |
| POST | `/api/activos/integracion/contabilidad/baja/{maestroId}` | Asiento baja sin venta. |
| POST | `/api/activos/integracion/contabilidad/traslado/{trasladoId}` | Reclasificación CC (valor neto) al ejecutar traslado. |
| GET | `/api/activos/integracion/contabilidad/trazabilidad` | Consulta asiento por origen. |
| POST | `/api/activos/integracion/compras/maestro-desde-orden-compra` | Alta desde línea OC. |
| POST | `/api/activos/integracion/compras/maestro-desde-recepcion` | Alta desde recepción de compra. |
| POST | `/api/activos/integracion/compras/maestro-desde-factura` | Alta desde línea OC facturada + datos factura proveedor. |
| GET/PUT | `/api/activos/maestro/{maestroId}/distribucion-cc` | Reparto % CC; prorratea gasto en depreciación. |
| GET | `/api/activos/reportes/libro-activos/export` | Export REP-001 (`csv`, `xlsx`, `pdf`). |

> **PDF:** `?formato=pdf` genera el **libro de activos** (HU-AF-REP-001): tabla código, nombre, V. adquisición, dep. acum., V. neto, estado. OpenPDF en `AfReporteExportServiceImpl`. JSON equivalente: `GET …/libro-activos`.

### Módulos origen (`moduloOrigen` en contabilidad)

| Código | Documento origen |
|--------|------------------|
| `AF_DEPRECIACION` | `af_calculo_cntbl.id` |
| `AF_DEVENGO_PRIMA` | `af_prima_devengo.id` |
| `AF_VENTA` | `af_venta.id` |
| `AF_VALUACION` | `af_valuacion.id` |
| `AF_ALTA_ACTIVO` | `af_maestro.id` |
| `AF_ADAPTACION` | `af_adaptacion.id` |
| `AF_BAJA_ACTIVO` | `af_maestro.id` |
| `AF_TRASLADO` | `af_traslado.id` |

Correlación en `referencia` del detalle: `AF|MAESTRO=…|PER=…|…`.

### Contabilización automática

Propiedad `app.integracion.contabilidad.contabilizar-automatico` (env `INTEGRACION_CONTABILIDAD_AUTO`, default `true`).

Se ejecuta tras: cálculo depreciación, devengo prima, aprobar venta/valuación, capitalizar adaptación, alta desde compras, desactivar maestro sin venta previa.

### Trazabilidad local (Flyway)

| Migración | Columnas |
|-----------|----------|
| `V202605161200` | `orden_compra_*`, `cntbl_asiento_id` en cálculo/devengo/venta/valuación |
| `V202605161500` | `recepcion_compra_id` en maestro |
| `V202605161600` | Cuentas matriz seguro/capitalización; `cntbl_asiento_id` en maestro y adaptación |
| `V202605171700` | Factura proveedor; `af_maestro_cc_distrib`; `cntbl_asiento_id` en traslado |

## Validación de cuentas en matriz contable

`AfMatrizSubClaseServiceImpl` valida IDs contra `contabilidad.plan_contable_det` en la BD del tenant.

## Configuración (`application.yml` → `app.integracion`)

- `contabilidad.habilitada`, `libro-id`, `tipo-asiento`, `contabilizar-automatico`, `contabilizar-traslado-automatico`
- `compras.habilitada`, `tolerancia-importe`

Variables Feign: `feign.client.config.ms-contabilidad.url`, `ms-compras.url`.

## Eventos de historial automáticos

- `AfHistorialRegistroService`: contabilizar (`AF_CONTABILIDAD`) y alta desde compra (`AF_COMPRAS`).
- `AfHistorialService`: eventos operativos en traslados, valuaciones, ventas, adaptaciones.

## ms-worker (cron)

`ActivosFijosScheduledJob` invoca `POST /api/activos/jobs/depreciacion-masiva` y `devengo-prima-masivo` (mes anterior). Config: `app.activos-jobs.*` en `ms-worker` (`ACTIVOS_JOBS_ENABLED`, `ACTIVOS_JOBS_BEARER_TOKEN`, crons, URL gateway).
