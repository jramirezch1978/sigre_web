import { AlmacenTablaKey } from './almacen-tablas.config';

export type TablaCampoTipo = 'text' | 'number' | 'select';

export interface TablaCrudCampo {
  key: string;
  label: string;
  type: TablaCampoTipo;
  required?: boolean;
  maxLength?: number;
  optionsFrom?: 'tipos-almacen' | 'sucursales';
}

export interface TablaCrudConfig {
  basePath: string;
  campos: TablaCrudCampo[];
}

export const ALMACEN_TABLA_CRUD: Partial<Record<AlmacenTablaKey, TablaCrudConfig>> = {
  almacenes: {
    basePath: '/almacenes',
    campos: [
      { key: 'codigo', label: 'Código', type: 'text', required: true, maxLength: 20 },
      { key: 'nombre', label: 'Nombre', type: 'text', required: true, maxLength: 150 },
      { key: 'almacenTipoId', label: 'Tipo de almacén', type: 'select', optionsFrom: 'tipos-almacen' },
      { key: 'sucursalId', label: 'Sucursal', type: 'select', optionsFrom: 'sucursales', required: true },
    ],
  },
  'tipos-almacen': {
    basePath: '/almacen-tipos',
    campos: [
      { key: 'codigo', label: 'Código', type: 'text', required: true, maxLength: 20 },
      { key: 'nombre', label: 'Nombre', type: 'text', required: true, maxLength: 120 },
    ],
  },
  'tipos-movimiento': {
    basePath: '/maestros/tipos-movimiento-catalogo',
    campos: [
      { key: 'tipoMov', label: 'Código', type: 'text', required: true, maxLength: 10 },
      { key: 'descTipoMov', label: 'Descripción', type: 'text', required: true, maxLength: 200 },
    ],
  },
  'motivos-traslado': {
    basePath: '/maestros/motivos-traslado',
    campos: [
      { key: 'codigo', label: 'Código', type: 'text', required: true, maxLength: 20 },
      { key: 'nombre', label: 'Nombre', type: 'text', required: true, maxLength: 120 },
    ],
  },
};

export function crudConfigPorTabla(tablaKey: AlmacenTablaKey): TablaCrudConfig | null {
  return ALMACEN_TABLA_CRUD[tablaKey] ?? null;
}
