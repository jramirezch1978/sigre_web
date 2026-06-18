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

export const ALMACEN_OPERACIONES_VISTAS: readonly AlmacenVistaDef[] = [
  {
    codigo: 'ALMACEN_OP_REQ_TRASLADO',
    nombre: 'Requerimientos de traslado entre almacenes',
    rutaFrontend: '/sigre/almacen/operaciones/req-traslado',
    tipo: 'listado',
    apiPath: '/ordenes-traslado',
    orden: 1,
    columnas: colsOtr,
  },
  {
    codigo: 'ALMACEN_OP_DESPACHO',
    nombre: 'Despacho de productos',
    rutaFrontend: '/sigre/almacen/operaciones/despacho',
    tipo: 'listado',
    apiPath: '/movimientos',
    orden: 2,
    columnas: colsMovimiento,
    subtitulo: 'Movimientos de salida / despacho',
  },
  {
    codigo: 'ALMACEN_OP_RECEPCION',
    nombre: 'Recepción de mercadería',
    rutaFrontend: '/sigre/almacen/operaciones/recepcion',
    tipo: 'listado',
    apiPath: '/movimientos',
    orden: 3,
    columnas: colsMovimiento,
    subtitulo: 'Movimientos de ingreso / recepción',
  },
  {
    codigo: 'ALMACEN_OP_ALMACENAMIENTO',
    nombre: 'Almacenamiento de mercadería',
    rutaFrontend: '/sigre/almacen/operaciones/almacenamiento',
    tipo: 'listado',
    apiPath: '/movimientos',
    orden: 4,
    columnas: colsMovimiento,
  },
  {
    codigo: 'ALMACEN_OP_DEVOLUCIONES',
    nombre: 'Registro y gestión de devoluciones',
    rutaFrontend: '/sigre/almacen/operaciones/devoluciones',
    tipo: 'listado',
    apiPath: '/movimientos',
    orden: 5,
    columnas: colsMovimiento,
  },
  {
    codigo: 'ALMACEN_OP_REPOSICION',
    nombre: 'Reposición de stock',
    rutaFrontend: '/sigre/almacen/operaciones/reposicion-stock',
    tipo: 'listado',
    apiPath: '/stock',
    orden: 6,
    columnas: colsStock,
    subtitulo: 'Stock actual para evaluar reposición',
  },
  {
    codigo: 'ALMACEN_OP_COMPARACION_INV',
    nombre: 'Comparación de inventario',
    rutaFrontend: '/sigre/almacen/operaciones/comparacion-inventario',
    tipo: 'listado',
    apiPath: '/reportes/comparacion-inventario',
    orden: 7,
    columnas: [
      { key: 'articuloCodigo', header: 'Código' },
      { key: 'articuloNombre', header: 'Artículo' },
      { key: 'cantidadSistema', header: 'Sistema', format: 'numero' },
      { key: 'cantidadFisica', header: 'Físico', format: 'numero' },
      { key: 'diferencia', header: 'Diferencia', format: 'numero' },
    ],
  },
  {
    codigo: 'ALMACEN_OP_MERMAS',
    nombre: 'Registro de Pérdidas/Mermas',
    rutaFrontend: '/sigre/almacen/operaciones/registro-perdidas',
    tipo: 'listado',
    apiPath: '/reportes/perdidas',
    orden: 8,
    columnas: [
      { key: 'fecha', header: 'Fecha', format: 'fecha' },
      { key: 'articuloCodigo', header: 'Código' },
      { key: 'articuloNombre', header: 'Artículo' },
      { key: 'cantidad', header: 'Cantidad', format: 'numero' },
      { key: 'motivo', header: 'Motivo' },
    ],
  },
] as const;

export const ALMACEN_CONSULTAS_VISTAS: readonly AlmacenVistaDef[] = [
  {
    codigo: 'ALMACEN_CONS_KARDEX',
    nombre: 'Kardex / Movimiento de inventario',
    rutaFrontend: '/sigre/almacen/consultas/kardex-movimientos',
    tipo: 'listado',
    apiPath: '/kardex',
    orden: 1,
    columnas: colsKardex,
  },
  {
    codigo: 'ALMACEN_CONS_ORD_COMPRA',
    nombre: 'Órdenes de compra',
    rutaFrontend: '/sigre/almacen/consultas/ordenes-compra',
    tipo: 'listado',
    apiPath: '/movimientos',
    orden: 2,
    columnas: colsMovimiento,
    subtitulo: 'Movimientos vinculados a órdenes de compra',
  },
  {
    codigo: 'ALMACEN_CONS_PRODUCTOS',
    nombre: 'Consulta de productos',
    rutaFrontend: '/sigre/almacen/consultas/consulta-articulos',
    tipo: 'listado',
    apiPath: '/stock',
    orden: 3,
    columnas: colsStock,
  },
  {
    codigo: 'ALMACEN_CONS_PRESTAMOS',
    nombre: 'Préstamos de mercadería',
    rutaFrontend: '/sigre/almacen/consultas/prestamos',
    tipo: 'listado',
    apiPath: '/movimientos',
    orden: 4,
    columnas: colsMovimiento,
  },
  {
    codigo: 'ALMACEN_CONS_DEV_PROV',
    nombre: 'Devoluciones a Proveedores',
    rutaFrontend: '/sigre/almacen/consultas/devoluciones',
    tipo: 'listado',
    apiPath: '/movimientos',
    orden: 5,
    columnas: colsMovimiento,
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
