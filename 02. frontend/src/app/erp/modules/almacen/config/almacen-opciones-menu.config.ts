import { AlmacenTablaKey } from './almacen-tablas.config';
import { ALMACEN_VISTAS_POR_CODIGO } from './almacen-vistas.config';

/** Tabla destino en core.numerador_documento (cuando aplica). */
export interface AlmacenOpcionMenuDef {
  codigo: string;
  nombre: string;
  rutaFrontend: string;
  tablaKey: AlmacenTablaKey;
  orden: number;
  /** Filtro nombre_tabla en core.numerador_documento (numeración de documentos). */
  nombreTablaDocumento?: string;
}

/** Tablas destino para numeración correlativa (core.fn_get_document_number). */
export const ALMACEN_NUMERADOR_TABLA_VALES = 'almacen.vale_mov';
export const ALMACEN_NUMERADOR_TABLA_OTR = 'almacen.orden_traslado';

/**
 * Tablas maestras Almacén — alineado con opciones_menu.txt [TABLAS].
 * Mantener sincronizado con auth.opcion_menu (seed / patches SQL).
 */
export const ALMACEN_TABLAS_OPCIONES: readonly AlmacenOpcionMenuDef[] = [
  {
    codigo: 'ALMACEN_TABLAS_ALMACEN',
    nombre: 'Maestro de almacenes',
    rutaFrontend: '/sigre/almacen/tablas/almacenes',
    tablaKey: 'almacenes',
    orden: 1,
  },
  {
    codigo: 'ALMACEN_TABLAS_TIPO_MOV',
    nombre: 'Tipos de movimientos de almacenes',
    rutaFrontend: '/sigre/almacen/tablas/tipos-movimiento',
    tablaKey: 'tipos-movimiento',
    orden: 2,
  },
  {
    codigo: 'ALMACEN_TABLAS_UBICACION',
    nombre: 'Ubicacion de Articulo',
    rutaFrontend: '/sigre/almacen/tablas/ubicaciones',
    tablaKey: 'ubicaciones',
    orden: 3,
  },
  {
    codigo: 'ALMACEN_TABLAS_MOV_POR_ALM',
    nombre: 'Movimientos por almacen',
    rutaFrontend: '/sigre/almacen/tablas/movimientos-almacen',
    tablaKey: 'movimientos-almacen',
    orden: 4,
  },
  {
    codigo: 'ALMACEN_TABLAS_POSICIONES',
    nombre: 'Posiciones por Almacen',
    rutaFrontend: '/sigre/almacen/tablas/posiciones',
    tablaKey: 'posiciones',
    orden: 5,
  },
  {
    codigo: 'ALMACEN_TABLAS_MOTIVO_TRASL',
    nombre: 'Motivos de traslado',
    rutaFrontend: '/sigre/almacen/tablas/motivos-traslado',
    tablaKey: 'motivos-traslado',
    orden: 6,
  },
  {
    codigo: 'ALMACEN_TABLAS_LOTES',
    nombre: 'Ingreso de Lotes',
    rutaFrontend: '/sigre/almacen/tablas/lotes',
    tablaKey: 'lotes',
    orden: 7,
  },
  {
    codigo: 'ALMACEN_TABLAS_UNID_CONV',
    nombre: 'Unidades de Conversión',
    rutaFrontend: '/sigre/almacen/tablas/unidades-conversion',
    tablaKey: 'unidades-conversion',
    orden: 8,
  },
  {
    codigo: 'ALMACEN_TABLAS_NUM_VALES',
    nombre: 'Vales',
    rutaFrontend: '/sigre/almacen/tablas/numeracion-vales',
    tablaKey: 'numeracion-vales',
    nombreTablaDocumento: ALMACEN_NUMERADOR_TABLA_VALES,
    orden: 9,
  },
  {
    codigo: 'ALMACEN_TABLAS_NUM_OTR',
    nombre: 'Orden de Traslado',
    rutaFrontend: '/sigre/almacen/tablas/numeracion-otr',
    tablaKey: 'numeracion-otr',
    nombreTablaDocumento: ALMACEN_NUMERADOR_TABLA_OTR,
    orden: 10,
  },
  {
    codigo: 'ALMACEN_TABLAS_PARAMETROS',
    nombre: 'Parametros del Sistema',
    rutaFrontend: '/sigre/almacen/tablas/parametros',
    tablaKey: 'parametros',
    orden: 11,
  },
] as const;

export const ALMACEN_TABLAS_POR_CODIGO: Readonly<Record<string, AlmacenOpcionMenuDef>> =
  Object.fromEntries(ALMACEN_TABLAS_OPCIONES.map(o => [o.codigo, o]));

export const ALMACEN_TABLAS_POR_RUTA: Readonly<Record<string, AlmacenOpcionMenuDef>> =
  Object.fromEntries(ALMACEN_TABLAS_OPCIONES.map(o => [o.rutaFrontend, o]));

/** Catálogo unificado código → ruta (11 tablas + 23 operaciones/consultas/reportes/procesos). */
export const ALMACEN_OPCIONES_POR_CODIGO: Readonly<Record<string, string>> = {
  ...Object.fromEntries(ALMACEN_TABLAS_OPCIONES.map(o => [o.codigo, o.rutaFrontend])),
  ...Object.fromEntries(
    Object.values(ALMACEN_VISTAS_POR_CODIGO).map(v => [v.codigo, v.rutaFrontend]),
  ),
};

/** Ruta relativa dentro del módulo almacén (sin prefijo /sigre/almacen). */
export function rutaRelativaAlmacen(rutaFrontend: string): string {
  const prefix = '/sigre/almacen/';
  return rutaFrontend.startsWith(prefix) ? rutaFrontend.slice(prefix.length) : rutaFrontend.replace(/^\//, '');
}

export function rutaFrontendPorCodigoOpcion(codigo: string): string | null {
  return ALMACEN_OPCIONES_POR_CODIGO[codigo.toUpperCase()] ?? null;
}

export function tablaKeyPorRutaFrontend(ruta: string): AlmacenTablaKey | null {
  const normal = ruta.startsWith('/sigre/') ? ruta : `/sigre${ruta.startsWith('/') ? '' : '/'}${ruta}`;
  return ALMACEN_TABLAS_POR_RUTA[normal]?.tablaKey ?? null;
}
