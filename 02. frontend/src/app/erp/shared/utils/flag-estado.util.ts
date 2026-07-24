/**
 * Catálogo virtual flag_estado (DDL: 00-convenciones-generales.sql).
 * 0 Anulado · 1 Activo · 2 Cerrado · 3 Pendiente · 4 Pagado parcial
 * 5 Pagado total · 6 En proceso · 7 Devuelto · 8 Suspendido · 9 Observado
 */
const ETIQUETAS: Record<string, string> = {
  '0': 'Anulado',
  '1': 'Activo',
  '2': 'Cerrado',
  '3': 'Pendiente',
  '4': 'Pagado parcial',
  '5': 'Pagado total',
  '6': 'En proceso',
  '7': 'Devuelto',
  '8': 'Suspendido',
  '9': 'Observado',
};

export function etiquetaFlagEstado(raw: unknown): string {
  if (raw == null || raw === '') {
    return '—';
  }
  if (raw === true) {
    return 'Activo';
  }
  if (raw === false) {
    return 'Anulado';
  }
  const v = String(raw).trim();
  return ETIQUETAS[v] ?? v;
}

export function esFlagEstadoActivo(raw: unknown): boolean {
  return raw === '1' || raw === 1 || raw === true;
}
