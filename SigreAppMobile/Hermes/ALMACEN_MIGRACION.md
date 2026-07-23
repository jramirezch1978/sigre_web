# Migración Almacén → Hermes

## Estado (paridad operativa móvil)

Catálogo **AL001–AL033** con:

| Capacidad | Cobertura |
|-----------|-----------|
| Listado GET | Todas las vistas de listado |
| Alta / edición tablas | AL001–AL012 (FAB + tap editar) |
| Alta / edición documentos | Movimientos, OTR, tomas (FAB + menú Editar) |
| Acciones | Confirmar/anular mov; aprobar/rechazar/cerrar/anular OTR; comparar/cerrar/anular inventario |
| Procesos POST | AL031–AL033 |
| Filtro vista | AL016 pendientes (`estado=P`) |

## Reglas de menú

- Sin opciones desactivadas ni hojas sin path.
- Navegación por código `AL###` / path.

## Notas UX móvil

- Selectores web (artículos, almacenes) se capturan por **ID numérico** en formularios.
- Tipos de movimiento: alta mínima (código, descripción, factor, estado); flags avanzados siguen en web.
