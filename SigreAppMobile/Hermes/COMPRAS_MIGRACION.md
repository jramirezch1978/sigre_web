# Migración Compras → Hermes

## Catálogo (paridad web implementada)

| Ventana | Opción | Capacidad móvil |
|---------|--------|-----------------|
| CM001 | Tipos proveedor | Listado + alta/edición |
| CM002 | Proveedores | Listado + alta/edición |
| CM003 | Solicitud de compra | Listado + detalle + enviar/aprobar/rechazar/anular/convertir + alta/edición |
| CM005 | Artículos | Listado + alta/edición |
| CM010–CM014 | Marcas, colores, clases, categorías, subcategorías | Listado + alta/edición |

## Navegación

Drawer `mi-menu` → `ComprasNavRouter` (path / CM###) → Activity.
Hub `ComprasOpcionesActivity` por grupos.

## Pendiente (web aún “en construcción”)

Cotizaciones, OC, OS, reportes y procesos del seed sin pantalla Angular real.
