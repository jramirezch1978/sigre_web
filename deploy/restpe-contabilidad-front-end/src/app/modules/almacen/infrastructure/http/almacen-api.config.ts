/**
 * Configuración de acceso al backend de microservicios para el módulo de almacén.
 *
 * Las llamadas se hacen con rutas RELATIVAS (`/api/almacen/...`) para que el
 * dev-server de Angular las reenvíe vía `proxy.conf.json` (`/api` →
 * panel.dev.contabilidad.restaurant.pe) y se evite CORS. En un despliegue donde
 * el front se sirva detrás del mismo gateway, las rutas relativas siguen siendo
 * correctas; si no, definir aquí el host absoluto del gateway.
 */
export const ALMACEN_GATEWAY_URL = '';

/** Prefijo común de todos los endpoints del microservicio de almacén. */
export const ALMACEN_API_PREFIX = '/api/almacen';

/** Base: relativa (`/api/almacen`) salvo que se configure un host en {@link ALMACEN_GATEWAY_URL}. */
export const ALMACEN_API_BASE = `${ALMACEN_GATEWAY_URL}${ALMACEN_API_PREFIX}`;

/**
 * Rutas de cada recurso del backend de almacén (relativas a {@link ALMACEN_API_BASE}).
 * Mantener alineadas con los `@RequestMapping` de los controllers de `ms-almacen`.
 */
export const ALMACEN_ENDPOINTS = {
  almacenes: '/almacenes',
  almacenTipos: '/almacen-tipos',
  ubicaciones: '/ubicaciones',
  stock: '/stock',
  movimientos: '/movimientos',
  ordenesTraslado: '/ordenes-traslado',
  guiasRemision: '/guias-remision',
  tomasInventario: '/tomas-inventario',
  solicitudesSalida: '/solicitudes-salida',
  lotesPallets: '/lotes-pallets',
  tiposMovimiento: '/tipos-movimiento',
  kardex: '/kardex',
  integraciones: '/integraciones',
  procesos: '/procesos',
  reportes: {
    valorizacion: '/reportes/valorizacion',
    lotesPorVencer: '/reportes/lotes-por-vencer',
    stockAFecha: '/reportes/stock-a-fecha',
    diagnostico: '/reportes/diagnostico',
    comparacionInventario: '/reportes/comparacion-inventario',
    perdidas: '/reportes/perdidas',
  },
  maestros: {
    tiposMovimientoCatalogo: '/maestros/tipos-movimiento-catalogo',
    motivosTraslado: '/maestros/motivos-traslado',
    articuloBonificaciones: '/maestros/articulo-bonificaciones',
  },
} as const;
