# Migración Almacén → Hermes

## Alcance funcional (paridad web “primera versión”)

Catálogo completo **AL001–AL033** (tablas + operaciones + consultas + reportes + procesos):

| Grupo | Ventanas | Móvil |
|-------|----------|--------|
| Tablas | AL001–AL012 | Listado GET (ubicaciones/tipos-mov-alm agregados; conversiones/numeración/params vía core) |
| Operaciones | AL013–AL018 | Listado + detalle; acciones confirmar/anular (mov), aprobar/rechazar/cerrar/anular (OTR), comparar/cerrar/anular (inventario) |
| Consultas | AL019–AL023 | Listado (+ detalle en vistas de movimientos) |
| Reportes | AL024–AL030 | Listado |
| Procesos | AL031–AL033 | POST ejecutar |

## Reglas de menú (drawer)

- No se cargan opciones desactivadas (`activo = false`).
- No se cargan hojas sin `pathUrl` / `rutaFrontend`.
- Navegación: código funcional → `AL###` en codigo/nombre → path → Activity.

## Pendiente (alta/edición tipo wizard web)

- Formulario crear/editar movimiento (líneas) y OTR
- CRUD completo de tablas maestras (hoy solo lectura)
- Filtros específicos por vista (tránsito, aprobación pendiente, stock mínimo, etc.)

## Navegación

Drawer `mi-menu` → `AlmacenNavRouter` → Activity.
Hub `AlmacenOpcionesActivity` lista grupos y todas las vistas navegables.
