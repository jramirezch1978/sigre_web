import { TablaColumna } from '../../../shared/models/api-page.model';

export type AlmacenVistaTipo = 'listado' | 'proceso';

export interface AlmacenVistaDef {
  codigo: string;
  nombre: string;
  rutaFrontend: string;
  tipo: AlmacenVistaTipo;
  orden: number;
  /** Ruta relativa bajo /api/almacen (GET listado o POST proceso). */
  apiPath?: string;
  /** Solo procesos: endpoint POST relativo. */
  procesoPath?: string;
  columnas: TablaColumna[];
  subtitulo?: string;
}

const colsKardex: TablaColumna[] = [
  { key: 'fecha', header: 'Fecha', format: 'fecha' },
  { key: 'articuloCodigo', header: 'Código' },
  { key: 'articuloNombre', header: 'Artículo' },
  { key: 'tipo', header: 'Tipo' },
  { key: 'cantidad', header: 'Cantidad', format: 'numero' },
  { key: 'costoUnitario', header: 'Costo unit.', format: 'numero' },
  { key: 'saldoCantidad', header: 'Saldo', format: 'numero' },
];

const colsMovimiento: TablaColumna[] = [
  { key: 'numero', header: 'Número' },
  { key: 'fecha', header: 'Fecha', format: 'fecha' },
  { key: 'tipoMov', header: 'Tipo mov.' },
  { key: 'almacenNombre', header: 'Almacén' },
  { key: 'estado', header: 'Estado' },
  { key: 'observacion', header: 'Observación' },
];

const colsOtr: TablaColumna[] = [
  { key: 'numero', header: 'Número' },
  { key: 'fecha', header: 'Fecha', format: 'fecha' },
  { key: 'almacenOrigenNombre', header: 'Origen' },
  { key: 'almacenDestinoNombre', header: 'Destino' },
  { key: 'estado', header: 'Estado' },
];

const colsStock: TablaColumna[] = [
  { key: 'articuloCodigo', header: 'Código' },
  { key: 'articuloNombre', header: 'Artículo' },
  { key: 'almacenNombre', header: 'Almacén' },
  { key: 'cantidadDisponible', header: 'Disponible', format: 'numero' },
  { key: 'costoPromedio', header: 'Costo prom.', format: 'numero' },
];

const colsValorizacion: TablaColumna[] = [
  { key: 'articuloCodigo', header: 'Código' },
  { key: 'articuloNombre', header: 'Artículo' },
  { key: 'cantidadDisponible', header: 'Cantidad', format: 'numero' },
  { key: 'costoPromedio', header: 'Costo prom.', format: 'numero' },
  { key: 'valorTotal', header: 'Valor total', format: 'numero' },
];

const colsDiagnostico: TablaColumna[] = [
  { key: 'almacenCodigo', header: 'Código' },
  { key: 'almacenNombre', header: 'Almacén' },
  { key: 'totalArticulos', header: 'Artículos', format: 'numero' },
  { key: 'totalUnidades', header: 'Unidades', format: 'numero' },
  { key: 'valorInventario', header: 'Valor inv.', format: 'numero' },
];

const colsTomaInv: TablaColumna[] = [
  { key: 'numero', header: 'Número' },
  { key: 'fecha', header: 'Fecha', format: 'fecha' },
  { key: 'almacenNombre', header: 'Almacén' },
  { key: 'estado', header: 'Estado' },
];

// Operaciones conciliadas con opciones_menu.txt que tienen endpoint GET de listado.
// Primera versión funcional = grilla de los registros existentes (datos reales del DDL).
// Las operaciones transaccionales sin endpoint de listado quedan en "en construcción".
export const ALMACEN_OPERACIONES_VISTAS: readonly AlmacenVistaDef[] = [
  {
    codigo: 'ALMACEN_OP_MOV_GENERAL',
    nombre: 'Movimiento de Almacén — General',
    rutaFrontend: '/sigre/almacen/operaciones/movimiento-general',
    tipo: 'listado',
    apiPath: '/movimientos',
    orden: 1,
    columnas: colsMovimiento,
    subtitulo: 'Movimientos de almacén registrados',
  },
  {
    codigo: 'ALMACEN_OP_MOV_TRANSITO',
    nombre: 'Movimiento de Almacén — Tránsito',
    rutaFrontend: '/sigre/almacen/operaciones/movimiento-transito',
    tipo: 'listado',
    apiPath: '/movimientos',
    orden: 2,
    columnas: colsMovimiento,
    subtitulo: 'Movimientos en tránsito',
  },
  {
    codigo: 'ALMACEN_OP_OTR_GENERACION',
    nombre: 'Orden de Traslado — Generación',
    rutaFrontend: '/sigre/almacen/operaciones/orden-traslado-generacion',
    tipo: 'listado',
    apiPath: '/ordenes-traslado',
    orden: 3,
    columnas: colsOtr,
  },
  {
    codigo: 'ALMACEN_OP_OTR_APROBACION',
    nombre: 'Orden de Traslado — Aprobación',
    rutaFrontend: '/sigre/almacen/operaciones/orden-traslado-aprobacion',
    tipo: 'listado',
    apiPath: '/ordenes-traslado',
    orden: 4,
    columnas: colsOtr,
    subtitulo: 'Órdenes de traslado pendientes de aprobación',
  },
  {
    codigo: 'ALMACEN_OP_INV_CONTEO',
    nombre: 'Inventarios — Ingreso por Conteo',
    rutaFrontend: '/sigre/almacen/operaciones/inventario-conteo',
    tipo: 'listado',
    apiPath: '/tomas-inventario',
    orden: 5,
    columnas: colsTomaInv,
  },
  {
    codigo: 'ALMACEN_OP_INV_MONITOR',
    nombre: 'Inventarios — Monitor por Conteo',
    rutaFrontend: '/sigre/almacen/operaciones/inventario-monitor',
    tipo: 'listado',
    apiPath: '/tomas-inventario',
    orden: 6,
    columnas: colsTomaInv,
  },
] as const;

// Consultas (solo lectura) conciliadas con opciones_menu.txt sobre endpoints GET reales.
export const ALMACEN_CONSULTAS_VISTAS: readonly AlmacenVistaDef[] = [
  {
    codigo: 'ALMACEN_CONS_MOV_ARTICULO',
    nombre: 'Movimientos x artículo',
    rutaFrontend: '/sigre/almacen/consultas/movimientos-x-articulo',
    tipo: 'listado',
    apiPath: '/kardex',
    orden: 1,
    columnas: colsKardex,
  },
  {
    codigo: 'ALMACEN_CONS_MOV_ALMACEN',
    nombre: 'Consulta de movimientos de almacén',
    rutaFrontend: '/sigre/almacen/consultas/consulta-movimientos-almacen',
    tipo: 'listado',
    apiPath: '/movimientos',
    orden: 2,
    columnas: colsMovimiento,
  },
  {
    codigo: 'ALMACEN_CONS_DEV_PREST',
    nombre: 'Devoluciones y Préstamos',
    rutaFrontend: '/sigre/almacen/consultas/devoluciones-y-prestamos',
    tipo: 'listado',
    apiPath: '/movimientos',
    orden: 3,
    columnas: colsMovimiento,
  },
  {
    codigo: 'ALMACEN_CONS_DESPACHOS',
    nombre: 'Despachos',
    rutaFrontend: '/sigre/almacen/consultas/despachos',
    tipo: 'listado',
    apiPath: '/movimientos',
    orden: 4,
    columnas: colsMovimiento,
    subtitulo: 'Movimientos de despacho / salida',
  },
  {
    codigo: 'ALMACEN_CONS_ESP_ARTICULOS',
    nombre: 'Consulta Especializada de Artículos',
    rutaFrontend: '/sigre/almacen/consultas/consulta-especializada-articulos',
    tipo: 'listado',
    apiPath: '/stock',
    orden: 5,
    columnas: colsStock,
  },
] as const;

export const ALMACEN_REPORTES_VISTAS: readonly AlmacenVistaDef[] = [
  {
    codigo: 'ALMACEN_REP_STOCK_FECHA',
    nombre: 'Stock a la fecha',
    rutaFrontend: '/sigre/almacen/reportes/stock-fecha',
    tipo: 'listado',
    apiPath: '/reportes/stock-a-fecha',
    orden: 1,
    columnas: colsStock,
  },
  {
    codigo: 'ALMACEN_REP_HIST_MOV',
    nombre: 'Historial de movimiento',
    rutaFrontend: '/sigre/almacen/reportes/historial-movimiento',
    tipo: 'listado',
    apiPath: '/kardex',
    orden: 2,
    columnas: colsKardex,
  },
  {
    codigo: 'ALMACEN_REP_VALORIZACION',
    nombre: 'Valorización',
    rutaFrontend: '/sigre/almacen/reportes/valorizacion',
    tipo: 'listado',
    apiPath: '/reportes/valorizacion',
    orden: 3,
    columnas: colsValorizacion,
  },
  {
    codigo: 'ALMACEN_REP_VENDIDOS_PERIODO',
    nombre: 'Productos vendidos por periodo',
    rutaFrontend: '/sigre/almacen/reportes/productos-vendidos-por-periodo',
    tipo: 'listado',
    apiPath: '/movimientos',
    orden: 4,
    columnas: colsMovimiento,
    subtitulo: 'Movimientos de salida por venta (en evolución)',
  },
  {
    codigo: 'ALMACEN_REP_STOCK_MINIMO',
    nombre: 'Stock mínimo',
    rutaFrontend: '/sigre/almacen/reportes/stock-minimo',
    tipo: 'listado',
    apiPath: '/stock',
    orden: 5,
    columnas: colsStock,
    subtitulo: 'Artículos bajo punto de reorden',
  },
  {
    codigo: 'ALMACEN_REP_DIAG',
    nombre: 'Diagnostico de almacenes',
    rutaFrontend: '/sigre/almacen/reportes/diagnostico-almacenes',
    tipo: 'listado',
    apiPath: '/reportes/diagnostico',
    orden: 6,
    columnas: colsDiagnostico,
    subtitulo: 'Respuesta sin paginación',
  },
  {
    codigo: 'ALMACEN_REP_TOMA_INV',
    nombre: 'Reportes de tomas de inventario',
    rutaFrontend: '/sigre/almacen/reportes/reporte-tomas-inventario',
    tipo: 'listado',
    apiPath: '/tomas-inventario',
    orden: 7,
    columnas: colsTomaInv,
  },
] as const;

export const ALMACEN_PROCESOS_VISTAS: readonly AlmacenVistaDef[] = [
  {
    codigo: 'ALMACEN_PROC_RECALCULO',
    nombre: 'Recálculo de precios promedio',
    rutaFrontend: '/sigre/almacen/procesos/recalcular',
    tipo: 'proceso',
    procesoPath: '/procesos/recalculo-precios-promedio',
    orden: 1,
    columnas: [],
    subtitulo: 'Recalcula costos promedio del inventario',
  },
  {
    codigo: 'ALMACEN_PROC_CUADRE_STOCK',
    nombre: 'Cuadres de stock',
    rutaFrontend: '/sigre/almacen/procesos/cuadre-stock',
    tipo: 'proceso',
    procesoPath: '/procesos/cuadre-stock',
    orden: 2,
    columnas: [],
    subtitulo: 'Cuadra stock vs posiciones de almacén',
  },
  {
    codigo: 'ALMACEN_PROC_ACT_AUTO',
    nombre: 'Actualización automática',
    rutaFrontend: '/sigre/almacen/procesos/actualizacion',
    tipo: 'proceso',
    procesoPath: '/procesos/actualizacion-automatica',
    orden: 3,
    columnas: [],
    subtitulo: 'Sincroniza saldos y costos pendientes',
  },
] as const;

export const ALMACEN_TODAS_VISTAS: readonly AlmacenVistaDef[] = [
  ...ALMACEN_OPERACIONES_VISTAS,
  ...ALMACEN_CONSULTAS_VISTAS,
  ...ALMACEN_REPORTES_VISTAS,
  ...ALMACEN_PROCESOS_VISTAS,
];

export const ALMACEN_VISTAS_POR_RUTA: Readonly<Record<string, AlmacenVistaDef>> = Object.fromEntries(
  ALMACEN_TODAS_VISTAS.map(v => [v.rutaFrontend, v]),
);

export const ALMACEN_VISTAS_POR_CODIGO: Readonly<Record<string, AlmacenVistaDef>> = Object.fromEntries(
  ALMACEN_TODAS_VISTAS.map(v => [v.codigo, v]),
);
