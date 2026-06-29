import { TablaCrudCampo, TablaCrudConfig, CrudHandler } from './almacen-tabla-crud.config';

export type VistaCrudHandler = Extract<CrudHandler, 'movimiento' | 'otr' | 'inventario' | 'standard'>;

export interface VistaCrudConfig extends TablaCrudConfig {
  handler: VistaCrudHandler;
  /** Valores por defecto al crear movimientos según opción de menú. */
  movimientoDefaults?: Record<string, string | number>;
}

const camposMovimiento: TablaCrudCampo[] = [
  { key: 'sucursalId', label: 'Sucursal', type: 'select', optionsFrom: 'sucursales', required: true },
  { key: 'almacenId', label: 'Almacén', type: 'select', optionsFrom: 'almacenes', required: true },
  { key: 'articuloMovTipoId', label: 'Tipo movimiento', type: 'select', optionsFrom: 'tipos-movimiento', required: true },
  { key: 'fechaMov', label: 'Fecha mov.', type: 'date', required: true },
  { key: 'articuloId', label: 'Artículo ID', type: 'number', required: true },
  { key: 'cantProcesada', label: 'Cantidad', type: 'number', required: true },
  { key: 'observaciones', label: 'Observaciones', type: 'text', maxLength: 500 },
];

const camposOtr: TablaCrudCampo[] = [
  { key: 'almacenOrigenId', label: 'Almacén origen', type: 'select', optionsFrom: 'almacenes', required: true },
  { key: 'almacenDestinoId', label: 'Almacén destino', type: 'select', optionsFrom: 'almacenes', required: true },
  { key: 'fecha', label: 'Fecha', type: 'date', required: true },
  { key: 'articuloId', label: 'Artículo ID', type: 'number', required: true },
  { key: 'cantidad', label: 'Cantidad', type: 'number', required: true },
  { key: 'observacion', label: 'Observación', type: 'text', maxLength: 500 },
];

const camposInventario: TablaCrudCampo[] = [
  { key: 'almacenId', label: 'Almacén', type: 'select', optionsFrom: 'almacenes', required: true },
  { key: 'articuloId', label: 'Artículo ID', type: 'number', required: true },
  { key: 'fechaConteo', label: 'Fecha conteo', type: 'date', required: true },
  { key: 'saldoSistema', label: 'Saldo sistema', type: 'number' },
  { key: 'cantidadConteo1', label: 'Conteo físico', type: 'number', required: true },
];

/** CRUD por código de opción de menú (operaciones, consultas editables, reportes con datos maestros). */
export const ALMACEN_VISTA_CRUD: Readonly<Record<string, VistaCrudConfig>> = {
  // Operaciones (alta/edición sobre endpoints reales). Conciliadas con opciones_menu.txt.
  ALMACEN_OP_MOV_GENERAL: {
    basePath: '/movimientos',
    handler: 'movimiento',
    campos: camposMovimiento,
  },
  ALMACEN_OP_MOV_TRANSITO: {
    basePath: '/movimientos',
    handler: 'movimiento',
    campos: camposMovimiento,
  },
  ALMACEN_OP_OTR_GENERACION: { basePath: '/ordenes-traslado', handler: 'otr', campos: camposOtr },
  ALMACEN_OP_OTR_APROBACION: { basePath: '/ordenes-traslado', handler: 'otr', campos: camposOtr },
  ALMACEN_OP_INV_CONTEO: {
    basePath: '/tomas-inventario',
    handler: 'inventario',
    campos: camposInventario,
  },
  ALMACEN_OP_INV_MONITOR: {
    basePath: '/tomas-inventario',
    handler: 'inventario',
    campos: camposInventario,
  },
  // Consultas: solo lectura (sin CRUD).
  // Reportes con datos transaccionales
  ALMACEN_REP_HIST_MOV: {
    basePath: '/movimientos',
    handler: 'movimiento',
    campos: camposMovimiento,
  },
  ALMACEN_REP_VENDIDOS_PERIODO: {
    basePath: '/movimientos',
    handler: 'movimiento',
    campos: camposMovimiento,
    movimientoDefaults: { tipoReferenciaOrigen: 'V' },
  },
  ALMACEN_REP_TOMA_INV: {
    basePath: '/tomas-inventario',
    handler: 'inventario',
    campos: camposInventario,
  },
  ALMACEN_REP_STOCK_FECHA: {
    basePath: '/movimientos',
    handler: 'movimiento',
    campos: camposMovimiento,
  },
  ALMACEN_REP_STOCK_MINIMO: {
    basePath: '/movimientos',
    handler: 'movimiento',
    campos: camposMovimiento,
    movimientoDefaults: { tipoReferenciaOrigen: 'I' },
  },
  ALMACEN_REP_VALORIZACION: {
    basePath: '/movimientos',
    handler: 'movimiento',
    campos: camposMovimiento,
  },
  ALMACEN_REP_DIAG: {
    basePath: '/movimientos',
    handler: 'movimiento',
    campos: camposMovimiento,
  },
};

export function crudConfigPorCodigoVista(codigo: string): VistaCrudConfig | null {
  return ALMACEN_VISTA_CRUD[codigo.toUpperCase()] ?? null;
}
