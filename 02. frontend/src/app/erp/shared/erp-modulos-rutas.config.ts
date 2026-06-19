/** Prefijos de código de opción de menú → código de módulo ERP. */
export const MODULOS_POR_PREFIJO: Readonly<Record<string, string>> = {
  ALMACEN: 'ALMACEN',
  COMPRAS: 'COMPRAS',
  APROVISIONAMIENTO: 'APROVISIONAMIENTO',
  APROV: 'APROVISIONAMIENTO',
  COMERCIALIZACION: 'COMERCIALIZACION',
  VENTAS: 'COMERCIALIZACION',
  FINANZAS: 'FINANZAS',
  CONTABILIDAD: 'CONTABILIDAD',
  ACTIVOS: 'ACTIVOS_FIJOS',
  ACTIVOS_FIJOS: 'ACTIVOS_FIJOS',
  RRHH: 'RRHH',
  PRODUCCION: 'PRODUCCION',
  PRESUPUESTO: 'PRESUPUESTO',
  FLOTA: 'FLOTA',
  MANTENIMIENTO: 'MANTENIMIENTO',
  AUDITORIA: 'AUDITORIA',
  CAMPO: 'CAMPO',
  COMEDOR: 'COMEDOR',
  SIG: 'SIG',
  OPERACIONES: 'OPERACIONES',
  HORECA: 'HORECA',
  SEGURIDAD: 'SEGURIDAD',
  CONFIGURACION: 'SEGURIDAD',
};

export function moduloDesdeCodigoOpcion(codigo: string): string | null {
  if (!codigo?.includes('_')) return null;
  const prefijo = codigo.split('_')[0]?.toUpperCase() ?? '';
  return MODULOS_POR_PREFIJO[prefijo] ?? null;
}

export function rutaDashboardModulo(codigoModulo: string): string {
  switch (codigoModulo.toUpperCase()) {
    case 'ALMACEN':
      return '/sigre/almacen';
    default:
      return `/sigre/m/${codigoModulo.toLowerCase()}`;
  }
}
