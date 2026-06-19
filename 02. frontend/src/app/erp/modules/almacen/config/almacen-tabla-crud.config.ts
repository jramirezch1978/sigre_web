import { AlmacenTablaKey } from './almacen-tablas.config';

export type TablaCampoTipo = 'text' | 'number' | 'select' | 'date';

export type CrudApiSource = 'almacen' | 'core';

export type CrudHandler =
  | 'standard'
  | 'ubicacion'
  | 'tipo-mov-asignacion'
  | 'conversion-unidad'
  | 'numerador-doc'
  | 'parametro'
  | 'movimiento'
  | 'otr'
  | 'inventario';

export interface TablaCrudCampo {
  key: string;
  label: string;
  type: TablaCampoTipo;
  required?: boolean;
  maxLength?: number;
  readonlyOnEdit?: boolean;
  optionsFrom?: 'tipos-almacen' | 'sucursales' | 'almacenes' | 'tipos-movimiento';
}

export interface TablaCrudConfig {
  basePath: string;
  apiSource?: CrudApiSource;
  handler?: CrudHandler;
  campos: TablaCrudCampo[];
  /** Tabla destino fija para numerador_documento. */
  nombreTablaDocumento?: string;
  permiteAnular?: boolean;
  permiteEliminar?: boolean;
}

export const ALMACEN_TABLA_CRUD: Partial<Record<AlmacenTablaKey, TablaCrudConfig>> = {
  almacenes: {
    basePath: '/almacenes',
    handler: 'standard',
    campos: [
      { key: 'codigo', label: 'Código', type: 'text', required: true, maxLength: 20 },
      { key: 'nombre', label: 'Nombre', type: 'text', required: true, maxLength: 150 },
      { key: 'almacenTipoId', label: 'Tipo de almacén', type: 'select', optionsFrom: 'tipos-almacen' },
      { key: 'sucursalId', label: 'Sucursal', type: 'select', optionsFrom: 'sucursales', required: true },
    ],
  },
  'tipos-almacen': {
    basePath: '/almacen-tipos',
    handler: 'standard',
    campos: [
      { key: 'codigo', label: 'Código', type: 'text', required: true, maxLength: 20 },
      { key: 'nombre', label: 'Nombre', type: 'text', required: true, maxLength: 120 },
    ],
  },
  'tipos-movimiento': {
    basePath: '/maestros/tipos-movimiento-catalogo',
    handler: 'standard',
    campos: [
      { key: 'tipoMov', label: 'Código', type: 'text', required: true, maxLength: 10, readonlyOnEdit: true },
      { key: 'descTipoMov', label: 'Descripción', type: 'text', required: true, maxLength: 200 },
    ],
  },
  ubicaciones: {
    basePath: '/ubicaciones',
    handler: 'ubicacion',
    permiteAnular: false,
    campos: [
      { key: 'almacenId', label: 'Almacén', type: 'select', optionsFrom: 'almacenes', required: true, readonlyOnEdit: true },
      { key: 'codigo', label: 'Código ubicación', type: 'text', required: true, maxLength: 20 },
      { key: 'nombre', label: 'Nombre', type: 'text', required: true, maxLength: 120 },
      { key: 'pasillo', label: 'Pasillo', type: 'text', maxLength: 30 },
      { key: 'estante', label: 'Estante', type: 'text', maxLength: 30 },
      { key: 'nivel', label: 'Nivel', type: 'text', maxLength: 30 },
    ],
  },
  'movimientos-almacen': {
    basePath: '/almacenes',
    handler: 'tipo-mov-asignacion',
    permiteAnular: false,
    permiteEliminar: true,
    campos: [
      { key: 'almacenId', label: 'Almacén', type: 'select', optionsFrom: 'almacenes', required: true, readonlyOnEdit: true },
      { key: 'articuloMovTipoId', label: 'Tipo de movimiento', type: 'select', optionsFrom: 'tipos-movimiento', required: true, readonlyOnEdit: true },
    ],
  },
  posiciones: {
    basePath: '/ubicaciones',
    handler: 'ubicacion',
    permiteAnular: false,
    campos: [
      { key: 'almacenId', label: 'Almacén', type: 'select', optionsFrom: 'almacenes', required: true, readonlyOnEdit: true },
      { key: 'codigo', label: 'Código posición', type: 'text', required: true, maxLength: 20 },
      { key: 'nombre', label: 'Descripción', type: 'text', required: true, maxLength: 120 },
      { key: 'pasillo', label: 'Pasillo', type: 'text', maxLength: 30 },
      { key: 'estante', label: 'Estante', type: 'text', maxLength: 30 },
      { key: 'nivel', label: 'Nivel', type: 'text', maxLength: 30 },
    ],
  },
  'motivos-traslado': {
    basePath: '/maestros/motivos-traslado',
    handler: 'standard',
    campos: [
      { key: 'codigo', label: 'Código', type: 'text', required: true, maxLength: 20 },
      { key: 'nombre', label: 'Nombre', type: 'text', required: true, maxLength: 120 },
    ],
  },
  lotes: {
    basePath: '/lotes-pallets',
    handler: 'standard',
    campos: [
      { key: 'almacenId', label: 'Almacén ID', type: 'number', required: true },
      { key: 'articuloId', label: 'Artículo ID', type: 'number', required: true },
      { key: 'nroLote', label: 'N° Lote', type: 'text', required: true, maxLength: 40 },
      { key: 'fechaProduccion', label: 'F. producción', type: 'date' },
      { key: 'fechaVencimiento', label: 'F. vencimiento', type: 'date' },
      { key: 'observacion', label: 'Observación', type: 'text', maxLength: 1000 },
    ],
  },
  'unidades-conversion': {
    basePath: '/conversiones-unidad',
    apiSource: 'core',
    handler: 'conversion-unidad',
    campos: [
      { key: 'articuloId', label: 'Artículo ID', type: 'number' },
      { key: 'umOrigenId', label: 'UM origen ID', type: 'number', required: true },
      { key: 'umDestinoId', label: 'UM destino ID', type: 'number', required: true },
      { key: 'factorConversion', label: 'Factor', type: 'number', required: true },
    ],
  },
  'numeracion-vales': {
    basePath: '/numeradores-documento',
    apiSource: 'core',
    handler: 'numerador-doc',
    nombreTablaDocumento: 'almacen.vale_mov',
    permiteEliminar: false,
    campos: [
      { key: 'sucursalId', label: 'Sucursal', type: 'select', optionsFrom: 'sucursales', required: true, readonlyOnEdit: true },
      { key: 'ano', label: 'Año', type: 'number', required: true, readonlyOnEdit: true },
      { key: 'ultNro', label: 'Próximo N°', type: 'number', required: true },
    ],
  },
  'numeracion-otr': {
    basePath: '/numeradores-documento',
    apiSource: 'core',
    handler: 'numerador-doc',
    nombreTablaDocumento: 'almacen.orden_traslado',
    permiteEliminar: false,
    campos: [
      { key: 'sucursalId', label: 'Sucursal', type: 'select', optionsFrom: 'sucursales', required: true, readonlyOnEdit: true },
      { key: 'ano', label: 'Año', type: 'number', required: true, readonlyOnEdit: true },
      { key: 'ultNro', label: 'Próximo N°', type: 'number', required: true },
    ],
  },
  parametros: {
    basePath: '/config/empresa',
    apiSource: 'core',
    handler: 'parametro',
    permiteAnular: false,
    permiteEliminar: false,
    campos: [
      { key: 'clave', label: 'Clave', type: 'text', readonlyOnEdit: true },
      { key: 'valor', label: 'Valor', type: 'text', required: true },
    ],
  },
};

export function crudConfigPorTabla(tablaKey: AlmacenTablaKey): TablaCrudConfig | null {
  return ALMACEN_TABLA_CRUD[tablaKey] ?? null;
}
