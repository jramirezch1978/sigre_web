# Migración Almacén → Hermes (plan)

## Análisis (sigre_web)

El ERP web (`02. frontend/.../almacen`) es **config-driven** (`almacen-vistas.config.ts`):
listados genéricos + diálogos MD para movimientos y OTR. Muchas opciones del menú seed
tienen `path_url = NULL` (en construcción también en web).

Backend `almacen-service` ya expone APIs para la mayoría de listados operativos.

## Fase 1 — HECHA (esta entrega)

Arquitectura móvil espejo web:
- `AlmacenVistasCatalog` + `AlmacenNavRouter` (resolución por **path** y por **código ventana AL###**)
- `AlmacenListadoActivity` (GET paginado)
- `AlmacenDetalleActivity` (detalle vale)
- `AlmacenProcesoActivity` (POST procesos)

### Reglas de menú (drawer)
- **No** se cargan opciones desactivadas (`activo = false`).
- **No** se cargan hojas sin `pathUrl` / `rutaFrontend` (ni aunque existan en seed).
- Secciones/módulos vacíos tras el filtro se podan.
- Navegación: código funcional → `AL013`… en codigo/nombre → path → Activity.

## Fase 2 — Alta / edición (siguiente)

- Formulario crear/editar movimiento (wizard líneas)
- Confirmar / anular vale
- OTR: aprobar / rechazar / cerrar
- Inventario: comparar / cerrar conteo

## Fase 3 — Operaciones legacy seed

Despacho simplificado, consignaciones, items no atender, devoluciones operativas,
ajustes valorización, ingreso masivo — **requieren** path_url + API en web primero.

## Navegación

Drawer `mi-menu` → `AlmacenNavRouter` → Activity.
Hub `AlmacenOpcionesActivity` lista grupos y todas las vistas.
