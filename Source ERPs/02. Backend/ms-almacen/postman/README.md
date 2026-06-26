# Postman — ms-almacen

Importar en Postman: **Import → File** → `ms-almacen.postman_collection.json`.

**Versión 2.0** — **138 requests** en 2 carpetas raíz:

| Carpeta | Contenido |
|---------|-----------|
| **ms-almacen** | 17 controllers REST (`/api/almacen`) + infra + RabbitMQ + costeo E2E |
| **ms-ventas** | OV create/confirmar/despachar para integración `salida-orden-venta` |

## Variables

| Variable | Default | Uso |
|----------|---------|-----|
| `baseUrl` | `http://localhost:9003` | ms-almacen |
| `baseUrlVentas` | `http://localhost:9010` | ms-ventas (carpeta ms-ventas) |
| `baseUrlProduccion` | `http://localhost:9009` | costeo batch |
| `accessToken` | — | JWT Bearer (colección) |
| `ordenVentaId`, `valeMovId`, … | IDs demo | Se actualizan con tests scripts |

## Flujos E2E

**Salida OV:** carpeta `ms-ventas` → crear/confirmar OV → `ms-almacen` → `15 Integraciones` → POST salida-orden-venta.

**Costeo producción:** `Integración Producción` → vale tipo P + confirmar → RabbitMQ/costeo ms-produccion → GET vale costoUnitario.

Regenerar JSON desde código: `node generate-ms-almacen-collection.js`.
