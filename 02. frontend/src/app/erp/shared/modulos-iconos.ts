/** Rutas de iconos SVG por código de módulo (landing, dashboard, menú). */
export const MODULOS_ICONOS: Readonly<Record<string, string>> = {
  ALMACEN: 'assets/imagenes/modulos/almacen.svg',
  COMPRAS: 'assets/imagenes/modulos/compras.svg',
  APROVISIONAMIENTO: 'assets/imagenes/modulos/aprovisionamiento.svg',
  COMERCIALIZACION: 'assets/imagenes/modulos/comercializacion.svg',
  FINANZAS: 'assets/imagenes/modulos/finanzas.svg',
  CONTABILIDAD: 'assets/imagenes/modulos/contabilidad.svg',
  ACTIVOS_FIJOS: 'assets/imagenes/modulos/activos-fijos.svg',
  ACTIVOS: 'assets/imagenes/modulos/activos-fijos.svg',
  RRHH: 'assets/imagenes/modulos/rrhh.svg',
  PRODUCCION: 'assets/imagenes/modulos/produccion.svg',
  PRESUPUESTO: 'assets/imagenes/modulos/presupuesto.svg',
  FLOTA: 'assets/imagenes/modulos/flota.svg',
  MANTENIMIENTO: 'assets/imagenes/modulos/mantenimiento.svg',
  AUDITORIA: 'assets/imagenes/modulos/auditoria.svg',
  CAMPO: 'assets/imagenes/modulos/campo.svg',
  COMEDOR: 'assets/imagenes/modulos/comedor.svg',
  SIG: 'assets/imagenes/modulos/sig.svg',
  OPERACIONES: 'assets/imagenes/modulos/operaciones.svg',
  HORECA: 'assets/imagenes/modulos/horeca.svg',
  SEGURIDAD: 'assets/imagenes/modulos/configuracion.svg',
};

export function iconoModulo(codigo: string): string {
  return MODULOS_ICONOS[codigo.toUpperCase()] ?? 'assets/imagenes/modulos/sig.svg';
}
