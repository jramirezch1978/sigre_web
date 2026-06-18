/**
 * Constantes del módulo de Activos Fijos.
 */

// ─────────────────────────────────────────────────────────────────────────────
// Estados de resultado
// ─────────────────────────────────────────────────────────────────────────────
export const ACTIVO_FIJO_ESTADO_RESULTADO = {
  EXITO:      '1',
  ADVERTENCIA:'2',
  ERROR:      '3',
} as const;

export type ActivoFijoEstadoResultado =
  typeof ACTIVO_FIJO_ESTADO_RESULTADO[keyof typeof ACTIVO_FIJO_ESTADO_RESULTADO];

// ─────────────────────────────────────────────────────────────────────────────
// Mensajes de fallback
// ─────────────────────────────────────────────────────────────────────────────
export const ACTIVO_FIJO_MENSAJES_FALLBACK = {
  GUARDADO_DESCRIPCION:    'El activo fijo se guardó correctamente',
  ELIMINADO_DESCRIPCION:   'El activo fijo se eliminó correctamente',
  ACTUALIZADO_DESCRIPCION: 'El activo fijo se actualizó correctamente',
  CARGADO_DESCRIPCION:     'Activos fijos cargados correctamente',
  ERROR_GENERAL:    'Ocurrió un error inesperado. Intente nuevamente.',
  ERROR_GUARDAR:    'Error al guardar el activo fijo',
  ERROR_ELIMINAR:   'Error al eliminar el activo fijo',
  ERROR_ACTUALIZAR: 'Error al actualizar el activo fijo',
  ERROR_CARGAR:     'Error al cargar los activos fijos',
} as const;

// ─────────────────────────────────────────────────────────────────────────────
// Mensajes de confirmación
// ─────────────────────────────────────────────────────────────────────────────
export const ACTIVO_FIJO_MENSAJES_CONFIRMACION = {
  ELIMINAR_TITULO: '¿Eliminar activo fijo?',
  ELIMINAR_DESCRIPCION: (descripcion: string) =>
    `Se eliminará el activo "${descripcion}". Esta acción no se puede deshacer.`,
} as const;

// ─────────────────────────────────────────────────────────────────────────────
// Textos de botones
// ─────────────────────────────────────────────────────────────────────────────
export const ACTIVO_FIJO_TEXTOS_BOTONES = {
  ELIMINAR: 'Eliminar',
  CANCELAR: 'Cancelar',
  GUARDAR:  'Guardar',
  NUEVO:    'Nuevo Activo',
} as const;

// ─────────────────────────────────────────────────────────────────────────────
// Duraciones de toasts (ms)
// ─────────────────────────────────────────────────────────────────────────────
export const ACTIVO_FIJO_TOAST_DURACION = {
  EXITO: 3000,
  ERROR: 5000,
} as const;

// ─────────────────────────────────────────────────────────────────────────────
// JSON path del mock de datos
// ─────────────────────────────────────────────────────────────────────────────
export const ACTIVO_FIJO_JSON_PATH = 'assets/data/activo-fijo/tabla/registro-activos.json';
