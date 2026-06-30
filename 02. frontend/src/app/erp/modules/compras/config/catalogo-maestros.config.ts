import { TablaColumna } from '../../../shared/models/api-page.model';

/** Un campo del formulario genérico de catálogo. */
export interface CatalogoCampo {
  key: string;
  label: string;
  type: 'text' | 'number' | 'select' | 'switch' | 'date';
  required?: boolean;
  maxLength?: number;
  readonlyOnEdit?: boolean;
  /** Para selects FK: endpoint core (relativo) del que se cargan las opciones. */
  optionsEndpoint?: string;
  /** Clave del id en las filas de opciones (por defecto 'id'). */
  optionsValueKey?: string;
  /** Claves a concatenar para la etiqueta de la opción (ej. ['codigo','nombre']). */
  optionsLabelKeys?: string[];
}

/** Configuración de un maestro de catálogo (CRUD genérico). */
export interface CatalogoMaestroConfig {
  codigo: string;
  nombre: string;
  /** Servicio base del endpoint (core por defecto). */
  base?: 'core' | 'compras';
  /** Endpoint relativo al servicio base, p.ej. '/marcas'. */
  endpoint: string;
  columnas: TablaColumna[];
  campos: CatalogoCampo[];
}

const ESTADO_COL: TablaColumna = { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' };
const ESTADO_CAMPO: CatalogoCampo = { key: 'flagEstado', label: 'Estado', type: 'switch' };

export const CATALOGO_MAESTROS: Record<string, CatalogoMaestroConfig> = {
  'tipos-proveedor': {
    codigo: 'CM001', nombre: 'Tipos de Proveedores', base: 'compras', endpoint: '/maestros/tipos-entidad-contribuyente',
    columnas: [
      { key: 'tipo', header: 'Código', width: '120px' },
      { key: 'descripcion', header: 'Descripción', width: '260px' },
      ESTADO_COL,
    ],
    campos: [
      { key: 'tipo', label: 'Código', type: 'text', required: true, maxLength: 10, readonlyOnEdit: true },
      { key: 'descripcion', label: 'Descripción', type: 'text', required: true, maxLength: 120 },
      ESTADO_CAMPO,
    ],
  },
  marcas: {
    codigo: 'CM010', nombre: 'Marcas', endpoint: '/marcas',
    columnas: [
      { key: 'codigo', header: 'Código', width: '120px' },
      { key: 'nombre', header: 'Nombre', width: '260px' },
      ESTADO_COL,
    ],
    campos: [
      { key: 'codigo', label: 'Código', type: 'text', required: true, maxLength: 20, readonlyOnEdit: true },
      { key: 'nombre', label: 'Nombre', type: 'text', required: true, maxLength: 120 },
      ESTADO_CAMPO,
    ],
  },
  colores: {
    codigo: 'CM011', nombre: 'Colores', endpoint: '/colores',
    columnas: [
      { key: 'codigo', header: 'Código', width: '120px' },
      { key: 'nombre', header: 'Nombre', width: '260px' },
      ESTADO_COL,
    ],
    campos: [
      { key: 'codigo', label: 'Código', type: 'text', required: true, maxLength: 20, readonlyOnEdit: true },
      { key: 'nombre', label: 'Nombre', type: 'text', required: true, maxLength: 120 },
      ESTADO_CAMPO,
    ],
  },
  'clases-articulo': {
    codigo: 'CM012', nombre: 'Clases de artículo', endpoint: '/clases-articulo',
    columnas: [
      { key: 'codClase', header: 'Código', width: '120px' },
      { key: 'descClase', header: 'Descripción', width: '260px' },
      ESTADO_COL,
    ],
    campos: [
      { key: 'codClase', label: 'Código', type: 'text', required: true, maxLength: 10, readonlyOnEdit: true },
      { key: 'descClase', label: 'Descripción', type: 'text', required: true, maxLength: 120 },
      ESTADO_CAMPO,
    ],
  },
  categorias: {
    codigo: 'CM013', nombre: 'Categorías de artículo', endpoint: '/categorias',
    columnas: [
      { key: 'catArt', header: 'Código', width: '120px' },
      { key: 'descCateg', header: 'Descripción', width: '260px' },
      ESTADO_COL,
    ],
    campos: [
      { key: 'catArt', label: 'Código', type: 'text', required: true, maxLength: 10, readonlyOnEdit: true },
      { key: 'descCateg', label: 'Descripción', type: 'text', required: true, maxLength: 120 },
      ESTADO_CAMPO,
    ],
  },
  articulos: {
    codigo: 'CM005', nombre: 'Maestro de Artículos', endpoint: '/articulos',
    columnas: [
      { key: 'codigo', header: 'Código', width: '120px' },
      { key: 'nombre', header: 'Nombre', width: '260px' },
      { key: 'tipo', header: 'Tipo', width: '110px' },
      { key: 'descripcion', header: 'Descripción', width: '220px' },
      ESTADO_COL,
    ],
    campos: [
      { key: 'codigo', label: 'Código', type: 'text', required: true, maxLength: 30, readonlyOnEdit: true },
      { key: 'nombre', label: 'Nombre', type: 'text', required: true, maxLength: 220 },
      { key: 'tipo', label: 'Tipo', type: 'text', required: true, maxLength: 20 },
      { key: 'descripcion', label: 'Descripción', type: 'text', maxLength: 500 },
      { key: 'unidadMedidaId', label: 'Unidad de medida', type: 'select', required: true, optionsEndpoint: '/unidades-medida', optionsLabelKeys: ['codigo', 'nombre'] },
      { key: 'articuloCategId', label: 'Categoría', type: 'select', optionsEndpoint: '/categorias', optionsLabelKeys: ['catArt', 'descCateg'] },
      { key: 'articuloSubCategId', label: 'Subcategoría', type: 'select', optionsEndpoint: '/sub-categorias', optionsLabelKeys: ['codSubCat', 'descSubcateg'] },
      { key: 'articuloClaseId', label: 'Clase', type: 'select', optionsEndpoint: '/clases-articulo', optionsLabelKeys: ['codClase', 'descClase'] },
      { key: 'marcaId', label: 'Marca', type: 'select', optionsEndpoint: '/marcas', optionsLabelKeys: ['codigo', 'nombre'] },
      { key: 'colorId', label: 'Color', type: 'select', optionsEndpoint: '/colores', optionsLabelKeys: ['codigo', 'nombre'] },
      ESTADO_CAMPO,
    ],
  },
  'sub-categorias': {
    codigo: 'CM014', nombre: 'Subcategorías de artículo', endpoint: '/sub-categorias',
    columnas: [
      { key: 'codSubCat', header: 'Código', width: '120px' },
      { key: 'descSubcateg', header: 'Descripción', width: '240px' },
      ESTADO_COL,
    ],
    campos: [
      { key: 'codSubCat', label: 'Código', type: 'text', required: true, maxLength: 10, readonlyOnEdit: true },
      { key: 'descSubcateg', label: 'Descripción', type: 'text', required: true, maxLength: 120 },
      {
        key: 'articuloCategId', label: 'Categoría', type: 'select', required: true,
        optionsEndpoint: '/categorias', optionsLabelKeys: ['catArt', 'descCateg'],
      },
      ESTADO_CAMPO,
    ],
  },
};

export function catalogoConfigPorKey(key: string): CatalogoMaestroConfig | null {
  return CATALOGO_MAESTROS[key] ?? null;
}
