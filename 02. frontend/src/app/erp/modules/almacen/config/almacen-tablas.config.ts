import { TablaColumna } from '../../../shared/models/api-page.model';

export type AlmacenTablaKey =
  | 'almacenes'
  | 'tipos-movimiento'
  | 'tipos-almacen'
  | 'ubicaciones'
  | 'movimientos-almacen'
  | 'posiciones'
  | 'motivos-traslado'
  | 'lotes'
  | 'unidades-conversion'
  | 'numeracion-vales'
  | 'numeracion-otr'
  | 'parametros';

export interface AlmacenTablaDef {
  /** Código de ventana estilo PowerBuilder (AL001). Clave de persistencia + prefijo de título. */
  codigo: string;
  titulo: string;
  subtitulo?: string;
  columnas: TablaColumna[];
}

export const ALMACEN_TABLAS: Record<AlmacenTablaKey, AlmacenTablaDef> = {
  almacenes: {
    codigo: 'AL001',
    titulo: 'Maestro de almacenes',
    columnas: [
      { key: 'codigo', header: 'Código', width: '90px' },
      { key: 'nombre', header: 'Nombre', width: '220px' },
      { key: 'almacenTipoNombre', header: 'Tipo', width: '160px' },
      { key: 'sucursalNombre', header: 'Sucursal', width: '140px' },
      { key: 'centrosCostoNombre', header: 'Centro de costos', width: '180px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  'tipos-movimiento': {
    codigo: 'AL002',
    titulo: 'Tipos de movimientos de almacenes',
    columnas: [
      { key: 'tipoMov', header: 'Código', width: '90px' },
      { key: 'descTipoMov', header: 'Descripción', width: '280px' },
      { key: 'flagContabiliza', header: 'Contabiliza', width: '100px', format: 'flag' },
      { key: 'codSunat', header: 'Cód. SUNAT', width: '100px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  'tipos-almacen': {
    codigo: 'AL003',
    titulo: 'Tipos de almacén',
    columnas: [
      { key: 'codigo', header: 'Código', width: '90px' },
      { key: 'nombre', header: 'Nombre', width: '220px' },
      { key: 'libroNombre', header: 'Libro contable', width: '220px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  ubicaciones: {
    codigo: 'AL004',
    titulo: 'Ubicacion de Articulo',
    columnas: [
      { key: 'almacenCodigo', header: 'Almacén', width: '90px' },
      { key: 'almacenNombre', header: 'Nombre almacén', width: '180px' },
      { key: 'codigo', header: 'Código ubic.', width: '110px' },
      { key: 'nombre', header: 'Nombre ubic.', width: '180px' },
      { key: 'pasillo', header: 'Pasillo', width: '90px' },
      { key: 'estante', header: 'Estante', width: '90px' },
      { key: 'nivel', header: 'Nivel', width: '80px' },
    ],
  },
  'movimientos-almacen': {
    codigo: 'AL005',
    titulo: 'Movimientos por almacen',
    columnas: [
      { key: 'almacenCodigo', header: 'Almacén', width: '90px' },
      { key: 'almacenNombre', header: 'Nombre almacén', width: '180px' },
      { key: 'tipoMov', header: 'Tipo mov.', width: '90px' },
      { key: 'descTipoMov', header: 'Descripción', width: '240px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  posiciones: {
    codigo: 'AL006',
    titulo: 'Posiciones por Almacen',
    columnas: [
      { key: 'almacenCodigo', header: 'Almacén', width: '90px' },
      { key: 'codigo', header: 'Código', width: '100px' },
      { key: 'pasillo', header: 'Pasillo', width: '100px' },
      { key: 'estante', header: 'Estante', width: '100px' },
      { key: 'nivel', header: 'Nivel', width: '80px' },
      { key: 'nombre', header: 'Descripción', width: '200px' },
    ],
  },
  'motivos-traslado': {
    codigo: 'AL007',
    titulo: 'Motivos de traslado',
    columnas: [
      { key: 'codigo', header: 'Código', width: '90px' },
      { key: 'nombre', header: 'Nombre', width: '280px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  lotes: {
    codigo: 'AL008',
    titulo: 'Ingreso de Lotes',
    columnas: [
      { key: 'nroLote', header: 'N° Lote', width: '120px' },
      { key: 'articuloId', header: 'Artículo ID', width: '100px' },
      { key: 'fechaProduccion', header: 'F. producción', width: '120px', format: 'fecha' },
      { key: 'fechaVencimiento', header: 'F. vencimiento', width: '120px', format: 'fecha' },
      { key: 'observacion', header: 'Observación', width: '200px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  'unidades-conversion': {
    codigo: 'AL009',
    titulo: 'Unidades de Conversión',
    columnas: [
      { key: 'umOrigenCodigo', header: 'UM origen', width: '100px' },
      { key: 'umOrigenNombre', header: 'Descripción origen', width: '180px' },
      { key: 'umDestinoCodigo', header: 'UM destino', width: '100px' },
      { key: 'umDestinoNombre', header: 'Descripción destino', width: '180px' },
      { key: 'factorConversion', header: 'Factor', width: '90px', format: 'numero' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  'numeracion-vales': {
    codigo: 'AL010',
    titulo: 'Numeración — Vales',
    subtitulo: 'Correlativo por sucursal y año (VALE_MOV)',
    columnas: [
      { key: 'sucursalCodigo', header: 'Sucursal', width: '90px' },
      { key: 'sucursalNombre', header: 'Nombre sucursal', width: '160px' },
      { key: 'ano', header: 'Año', width: '70px' },
      { key: 'ultNro', header: 'Próximo N°', width: '100px', format: 'numero' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  'numeracion-otr': {
    codigo: 'AL011',
    titulo: 'Numeración — OTR',
    subtitulo: 'Correlativo por sucursal y año (ORDEN_TRASLADO)',
    columnas: [
      { key: 'sucursalCodigo', header: 'Sucursal', width: '90px' },
      { key: 'sucursalNombre', header: 'Nombre sucursal', width: '160px' },
      { key: 'ano', header: 'Año', width: '70px' },
      { key: 'ultNro', header: 'Próximo N°', width: '100px', format: 'numero' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  parametros: {
    codigo: 'AL012',
    titulo: 'Parametros del Sistema',
    columnas: [
      { key: 'clave', header: 'Clave', width: '160px' },
      { key: 'descripcion', header: 'Descripción', width: '260px' },
      { key: 'tipoDato', header: 'Tipo', width: '90px' },
      { key: 'nivel', header: 'Nivel', width: '90px' },
      { key: 'valor', header: 'Valor', width: '140px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
};
