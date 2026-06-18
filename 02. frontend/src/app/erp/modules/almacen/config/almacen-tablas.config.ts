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
  titulo: string;
  subtitulo?: string;
  columnas: TablaColumna[];
}

export const ALMACEN_TABLAS: Record<AlmacenTablaKey, AlmacenTablaDef> = {
  almacenes: {
    titulo: 'Maestro de almacenes',
    columnas: [
      { key: 'codigo', header: 'Código', width: '90px' },
      { key: 'nombre', header: 'Nombre', width: '220px' },
      { key: 'almacenTipoNombre', header: 'Tipo', width: '120px' },
      { key: 'sucursalNombre', header: 'Sucursal', width: '140px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  'tipos-movimiento': {
    titulo: 'Tipos de movimientos de almacén',
    columnas: [
      { key: 'tipoMov', header: 'Código', width: '90px' },
      { key: 'descTipoMov', header: 'Descripción', width: '280px' },
      { key: 'flagContabiliza', header: 'Contabiliza', width: '100px' },
      { key: 'codSunat', header: 'Cód. SUNAT', width: '100px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  'tipos-almacen': {
    titulo: 'Tipos de almacén',
    columnas: [
      { key: 'codigo', header: 'Código', width: '90px' },
      { key: 'nombre', header: 'Nombre', width: '240px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  ubicaciones: {
    titulo: 'Ubicación de artículo',
    subtitulo: 'Ubicaciones físicas por almacén',
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
    titulo: 'Movimientos por almacén',
    subtitulo: 'Tipos de movimiento habilitados por almacén',
    columnas: [
      { key: 'almacenCodigo', header: 'Almacén', width: '90px' },
      { key: 'almacenNombre', header: 'Nombre almacén', width: '180px' },
      { key: 'tipoMov', header: 'Tipo mov.', width: '90px' },
      { key: 'descTipoMov', header: 'Descripción', width: '240px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  posiciones: {
    titulo: 'Posiciones por almacén',
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
    titulo: 'Motivos de traslado',
    columnas: [
      { key: 'codigo', header: 'Código', width: '90px' },
      { key: 'nombre', header: 'Nombre', width: '280px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  lotes: {
    titulo: 'Ingreso de lotes',
    columnas: [
      { key: 'nroLote', header: 'N° Lote', width: '120px' },
      { key: 'almacenId', header: 'Almacén ID', width: '100px' },
      { key: 'articuloId', header: 'Artículo ID', width: '100px' },
      { key: 'fechaProduccion', header: 'F. producción', width: '120px', format: 'fecha' },
      { key: 'fechaVencimiento', header: 'F. vencimiento', width: '120px', format: 'fecha' },
      { key: 'observacion', header: 'Observación', width: '200px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  'unidades-conversion': {
    titulo: 'Unidades de conversión',
    columnas: [
      { key: 'articuloId', header: 'Artículo ID', width: '100px' },
      { key: 'umOrigenId', header: 'UM origen', width: '100px' },
      { key: 'umDestinoId', header: 'UM destino', width: '100px' },
      { key: 'factorConversion', header: 'Factor', width: '100px', format: 'numero' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  'numeracion-vales': {
    titulo: 'Numeración — Vales',
    subtitulo: 'Numeradores relacionados con vales de almacén',
    columnas: [
      { key: 'codigo', header: 'Código', width: '120px' },
      { key: 'nombre', header: 'Nombre', width: '220px' },
      { key: 'serie', header: 'Serie', width: '90px' },
      { key: 'ultimoNumero', header: 'Último N°', width: '110px', format: 'numero' },
      { key: 'longitud', header: 'Longitud', width: '90px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  'numeracion-otr': {
    titulo: 'Numeración — Orden de traslado',
    columnas: [
      { key: 'codigo', header: 'Código', width: '120px' },
      { key: 'nombre', header: 'Nombre', width: '220px' },
      { key: 'serie', header: 'Serie', width: '90px' },
      { key: 'ultimoNumero', header: 'Último N°', width: '110px', format: 'numero' },
      { key: 'longitud', header: 'Longitud', width: '90px' },
      { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
    ],
  },
  parametros: {
    titulo: 'Parámetros del sistema',
    subtitulo: 'Configuración del módulo Almacén',
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

export function filtroNumeradorVales(codigo: string, nombre: string): boolean {
  const t = `${codigo} ${nombre}`.toUpperCase();
  return t.includes('VALE') || t.includes('VM') || t.includes('MOV');
}

export function filtroNumeradorOtr(codigo: string, nombre: string): boolean {
  const t = `${codigo} ${nombre}`.toUpperCase();
  return t.includes('TRASL') || t.includes('OTR') || t.includes('ORDEN');
}
