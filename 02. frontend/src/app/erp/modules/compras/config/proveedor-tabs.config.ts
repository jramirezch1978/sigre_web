import { TablaColumna } from '../../../shared/models/api-page.model';
import { CatalogoCampo } from './catalogo-maestros.config';

/** Un tab de detalle (sub-recurso) de la Ficha de Proveedores/Clientes. */
export interface ProveedorSubTab {
  key: string;
  label: string;
  /** Sufijo del sub-recurso bajo /relaciones-comerciales/{id}. */
  endpointSuffix: string;
  /** Clave en el detalle del maestro de la que sale la lista (si viene en el GET /{id}). */
  detalleKey?: string;
  columnas: TablaColumna[];
  campos: CatalogoCampo[];
  /** El backend soporta editar/eliminar (PUT/DELETE) este sub-recurso. */
  editable: boolean;
}

/** Campos del tab "Datos generales" (maestro core.entidad_contribuyente). */
export const PROVEEDOR_DATOS_GENERALES: CatalogoCampo[] = [
  { key: 'razonSocial', label: 'Razón social / Nombre', type: 'text', required: true, maxLength: 200 },
  { key: 'nombreComercial', label: 'Nombre comercial', type: 'text', maxLength: 300 },
  { key: 'tipoDocIdentidadId', label: 'Tipo de documento', type: 'select', required: true, optionsEndpoint: '/tipos-documento-identidad', optionsLabelKeys: ['codigo', 'nombre'] },
  { key: 'nroDocumento', label: 'N° documento', type: 'text', required: true, maxLength: 30 },
  { key: 'tipoEntidadContribuyenteId', label: 'Tipo de proveedor', type: 'select', optionsEndpoint: 'compras:/maestros/tipos-entidad-contribuyente', optionsLabelKeys: ['tipo', 'descripcion'] },
  { key: 'direccion', label: 'Dirección', type: 'text', maxLength: 300 },
  { key: 'telefono', label: 'Teléfono', type: 'text', maxLength: 40 },
  { key: 'email', label: 'Email', type: 'text', maxLength: 150 },
  { key: 'esProveedor', label: 'Es proveedor', type: 'switch' },
  { key: 'esCliente', label: 'Es cliente', type: 'switch' },
  { key: 'esEmpleado', label: 'Es trabajador', type: 'switch' },
  { key: 'flagEstado', label: 'Estado', type: 'switch' },
];

const ESTADO_COL: TablaColumna = { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' };

/** Tabs de detalle (sub-recursos). */
export const PROVEEDOR_SUBTABS: ProveedorSubTab[] = [
  {
    key: 'direcciones', label: 'Direcciones', endpointSuffix: 'tiendas', editable: false,
    columnas: [
      { key: 'codigo', header: 'Código', width: '110px' },
      { key: 'nombre', header: 'Descripción', width: '200px' },
      { key: 'direccion', header: 'Dirección', width: '260px' },
    ],
    campos: [
      { key: 'codigo', label: 'Código', type: 'text', required: true, maxLength: 20 },
      { key: 'nombre', label: 'Descripción', type: 'text', required: true, maxLength: 120 },
      { key: 'direccion', label: 'Dirección', type: 'text', maxLength: 300 },
    ],
  },
  {
    key: 'cuentas', label: 'Cuentas bancarias', endpointSuffix: 'cuentas-bancarias', detalleKey: 'cuentasBancarias', editable: true,
    columnas: [
      { key: 'codBanco', header: 'Banco', width: '90px' },
      { key: 'numeroCuenta', header: 'N° cuenta', width: '160px' },
      { key: 'cci', header: 'CCI', width: '160px' },
    ],
    campos: [
      { key: 'codBanco', label: 'Código banco', type: 'text', maxLength: 3 },
      { key: 'numeroCuenta', label: 'N° cuenta', type: 'text', required: true, maxLength: 30 },
      { key: 'cci', label: 'CCI', type: 'text', maxLength: 30 },
      { key: 'monedaId', label: 'Moneda', type: 'select', required: true, optionsEndpoint: '/monedas', optionsLabelKeys: ['codigo', 'nombre'] },
      { key: 'tipoCuenta', label: 'Tipo de cuenta', type: 'text', maxLength: 30 },
    ],
  },
  {
    key: 'lineas-credito', label: 'Líneas de crédito', endpointSuffix: 'lineas-credito', detalleKey: 'lineasCredito', editable: true,
    columnas: [
      { key: 'limiteCredito', header: 'Límite', width: '130px', format: 'numero' },
      { key: 'diasCredito', header: 'Días', width: '90px', format: 'numero' },
      { key: 'fechaVencimiento', header: 'Vencimiento', width: '130px', format: 'fecha' },
      ESTADO_COL,
    ],
    campos: [
      { key: 'monedaId', label: 'Moneda', type: 'select', optionsEndpoint: '/monedas', optionsLabelKeys: ['codigo', 'nombre'] },
      { key: 'limiteCredito', label: 'Límite de crédito', type: 'number', required: true },
      { key: 'diasCredito', label: 'Días de crédito', type: 'number', required: true },
      { key: 'fechaVencimiento', label: 'Fecha de vencimiento', type: 'date' },
    ],
  },
  {
    key: 'representantes', label: 'Representantes', endpointSuffix: 'representantes', detalleKey: 'representantes', editable: false,
    columnas: [
      { key: 'nombre', header: 'Nombre', width: '200px' },
      { key: 'cargo', header: 'Cargo', width: '160px' },
      { key: 'telefono', header: 'Teléfono', width: '120px' },
      { key: 'email', header: 'Email', width: '180px' },
    ],
    campos: [
      { key: 'nombre', label: 'Nombre', type: 'text', required: true, maxLength: 150 },
      { key: 'cargo', label: 'Cargo', type: 'text', maxLength: 120 },
      { key: 'telefono', label: 'Teléfono', type: 'text', maxLength: 40 },
      { key: 'email', label: 'Email', type: 'text', maxLength: 150 },
    ],
  },
  {
    key: 'telefonos', label: 'Teléfonos', endpointSuffix: 'telefonos', detalleKey: 'telefonos', editable: false,
    columnas: [
      { key: 'descripcion', header: 'Descripción', width: '180px' },
      { key: 'codigoPais', header: 'País', width: '80px' },
      { key: 'codigoCiudad', header: 'Ciudad', width: '90px' },
      { key: 'numero', header: 'Número', width: '160px' },
    ],
    campos: [
      { key: 'descripcion', label: 'Descripción', type: 'text', maxLength: 60 },
      { key: 'codigoPais', label: 'Código país', type: 'text', maxLength: 5 },
      { key: 'codigoCiudad', label: 'Código ciudad', type: 'text', maxLength: 5 },
      { key: 'numero', label: 'Número', type: 'text', required: true, maxLength: 40 },
    ],
  },
];
