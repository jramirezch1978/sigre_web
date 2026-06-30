import { AlmacenTablaKey } from './almacen-tablas.config';

export type TablaCampoTipo = 'text' | 'number' | 'select' | 'select-text' | 'date' | 'switch' | 'centros-costo' | 'saldo-factor' | 'textarea' | 'articulo';

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
  optionsFrom?: 'tipos-almacen' | 'sucursales' | 'almacenes' | 'tipos-movimiento' | 'centros-costo' | 'proveedores' | 'ubigeos' | 'usuarios-empresa' | 'unidades' | 'libros-contables' | 'sunat-tab12';
  /** Etiqueta cuando el switch está encendido (flag_estado = 1). */
  switchOnLabel?: string;
  /** Etiqueta cuando el switch está apagado (flag_estado = 0). */
  switchOffLabel?: string;
  /** Valor inicial al crear un registro nuevo (switch: boolean; number: numérico). */
  defaultValue?: unknown;
}

/** Campo reutilizable para flag_estado binario (0/1). */
export const CAMPO_FLAG_ESTADO: TablaCrudCampo = {
  key: 'flagEstado',
  label: 'Estado',
  type: 'switch',
  switchOnLabel: 'Activo',
  switchOffLabel: 'Anulado',
};

/** Helper: flag binario Sí/No (apagado por defecto). */
function flagSiNo(key: string, label: string): TablaCrudCampo {
  return { key, label, type: 'switch', switchOnLabel: 'Sí', switchOffLabel: 'No', defaultValue: false };
}

/** Helper: factor de saldo tri-estado (Incrementa=1 / Disminuye=-1 / Nada=0). */
function factor(key: string, label: string): TablaCrudCampo {
  return { key, label, type: 'saldo-factor', defaultValue: 0 };
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
      // Obligatorios (BD NOT NULL + @NotBlank/@NotNull + required en formulario)
      { key: 'codigo', label: 'Código', type: 'text', required: true, maxLength: 20, readonlyOnEdit: true },
      { key: 'nombre', label: 'Nombre', type: 'text', required: true, maxLength: 150 },
      { key: 'sucursalId', label: 'Sucursal', type: 'select', optionsFrom: 'sucursales', required: true },
      // Opcionales (nullable en BD, sin @NotNull en DTO)
      { key: 'almacenTipoId', label: 'Tipo de almacén', type: 'select', optionsFrom: 'tipos-almacen' },
      { key: 'centrosCostoId', label: 'Centro de costo', type: 'centros-costo' },
      { key: 'proveedorEntidadId', label: 'Proveedor', type: 'select', optionsFrom: 'proveedores' },
      { key: 'responsableUsuarioId', label: 'Responsable', type: 'select', optionsFrom: 'usuarios-empresa' },
      { key: 'direccion', label: 'Dirección', type: 'text', maxLength: 80 },
      { key: 'ubigeo', label: 'Ubigeo', type: 'select', optionsFrom: 'ubigeos' },
      { key: 'areaTotal', label: 'Área total (m²)', type: 'number' },
      { key: 'volTotal', label: 'Volumen total (m³)', type: 'number' },
      { key: 'codSunat', label: 'Código SUNAT', type: 'text', maxLength: 4 },
      { key: 'flagCntrlLote', label: 'Control de lote', type: 'switch', switchOnLabel: 'Sí', switchOffLabel: 'No' },
      { key: 'flagVirtual', label: 'Almacén virtual', type: 'switch', switchOnLabel: 'Sí', switchOffLabel: 'No' },
      CAMPO_FLAG_ESTADO,
    ],
  },
  'tipos-almacen': {
    basePath: '/almacen-tipos',
    handler: 'standard',
    campos: [
      { key: 'codigo', label: 'Código', type: 'text', required: true, maxLength: 20, readonlyOnEdit: true },
      { key: 'nombre', label: 'Nombre', type: 'text', required: true, maxLength: 120 },
      { key: 'cntblLibroId', label: 'Libro contable', type: 'select', optionsFrom: 'libros-contables', required: true },
      CAMPO_FLAG_ESTADO,
    ],
  },
  'tipos-movimiento': {
    basePath: '/maestros/tipos-movimiento-catalogo',
    handler: 'standard',
    campos: [
      // Identificación
      { key: 'tipoMov', label: 'Código', type: 'text', required: true, maxLength: 10, readonlyOnEdit: true },
      { key: 'descTipoMov', label: 'Descripción', type: 'text', required: true, maxLength: 200 },
      { key: 'tipoMovDev', label: 'Tipo mov. devolución', type: 'text', maxLength: 10 },
      // El ingreso/salida lo define "Factor saldo total" (+1 ingreso / -1 salida); no hay campo Clase.
      { key: 'codSunat', label: 'Código SUNAT (Tabla 12)', type: 'select-text', optionsFrom: 'sunat-tab12' },
      // Factores de saldo (afectación de stock)
      factor('factorSldoTotal', 'Factor saldo total'),
      factor('factorSldoXLlegar', 'Factor saldo por llegar'),
      factor('factorSldoSol', 'Factor saldo solicitado'),
      factor('factorSldoDev', 'Factor saldo devolución'),
      factor('factorSldoPres', 'Factor saldo préstamo'),
      factor('factorSldoConsig', 'Factor saldo consignación'),
      factor('factorSldoReservado', 'Factor saldo reservado'),
      factor('factorCtrlTempla', 'Factor control templado'),
      // Banderas de comportamiento
      flagSiNo('flagContabiliza', 'Contabiliza'),
      flagSiNo('flagAjusteValorizacion', 'Ajuste valorización'),
      flagSiNo('flagMovEntreAlm', 'Movimiento entre almacenes'),
      flagSiNo('flagSolicitaProv', 'Solicita proveedor'),
      flagSiNo('flagSolicitaDocInt', 'Solicita doc. interno'),
      flagSiNo('flagSolicitaDocExt', 'Solicita doc. externo'),
      flagSiNo('flagSolicitaRef', 'Solicita referencia'),
      flagSiNo('flagSolicitaLote', 'Solicita lote'),
      flagSiNo('flagSolicitaPrecio', 'Solicita precio'),
      flagSiNo('flagSolicitaCenbef', 'Solicita centro beneficio'),
      flagSiNo('flagCntrlCtaCte', 'Controla cuenta corriente'),
      flagSiNo('flagCambiaPrecio', 'Permite cambiar precio'),
      flagSiNo('flagAmp', 'Afecta AMP (costo promedio)'),
      CAMPO_FLAG_ESTADO,
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
      { key: 'codigo', label: 'Código', type: 'text', required: true, maxLength: 20, readonlyOnEdit: true },
      { key: 'nombre', label: 'Nombre', type: 'text', required: true, maxLength: 120 },
      CAMPO_FLAG_ESTADO,
    ],
  },
  lotes: {
    basePath: '/lotes-pallets',
    handler: 'standard',
    campos: [
      { key: 'articuloId', label: 'Artículo', type: 'articulo', required: true },
      { key: 'nroLote', label: 'N° Lote', type: 'text', required: true, maxLength: 40 },
      { key: 'fechaProduccion', label: 'F. producción', type: 'date' },
      { key: 'fechaVencimiento', label: 'F. vencimiento', type: 'date' },
      { key: 'observacion', label: 'Observación', type: 'textarea', maxLength: 1000 },
      CAMPO_FLAG_ESTADO,
    ],
  },
  'unidades-conversion': {
    basePath: '/conversiones-unidad',
    apiSource: 'core',
    handler: 'conversion-unidad',
    campos: [
      { key: 'umOrigenId', label: 'UM origen', type: 'select', optionsFrom: 'unidades', required: true },
      { key: 'umDestinoId', label: 'UM destino', type: 'select', optionsFrom: 'unidades', required: true },
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
      CAMPO_FLAG_ESTADO,
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
      CAMPO_FLAG_ESTADO,
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
