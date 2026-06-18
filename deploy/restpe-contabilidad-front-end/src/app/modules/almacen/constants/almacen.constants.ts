/**
 * @summary Constantes para el módulo de Almacenes
 * @description Define mensajes, duraciones y configuraciones reutilizables
 */

// ─────────────────────────────────────────────────────────────────────────────
// Estados de resultado (alineados con HTTP_RESPONSE del core)
// ─────────────────────────────────────────────────────────────────────────────
export const ALMACEN_ESTADO_RESULTADO = {
  /** Operación exitosa */
  EXITO: '1',
  /** Advertencia en la operación */
  ADVERTENCIA: '2',
  /** Error en la operación */
  ERROR: '3',
} as const;

export type AlmacenEstadoResultado = typeof ALMACEN_ESTADO_RESULTADO[keyof typeof ALMACEN_ESTADO_RESULTADO];

// ─────────────────────────────────────────────────────────────────────────────
// Mensajes de fallback (solo se usan si el backend no envía mensaje)
// ─────────────────────────────────────────────────────────────────────────────
export const ALMACEN_MENSAJES_FALLBACK = {
  GUARDADO_DESCRIPCION: 'Almacén registrado correctamente',
  ELIMINADO_DESCRIPCION: 'El almacén se eliminó correctamente',
  ACTUALIZADO_DESCRIPCION: 'Almacén actualizado correctamente',
  CARGADO_DESCRIPCION: 'Almacenes cargados correctamente',
  ERROR_GENERAL: 'Ocurrió un error inesperado. Intente nuevamente.',
  ERROR_GUARDAR: 'Error al guardar el almacén',
  ERROR_ELIMINAR: 'Error al eliminar el almacén',
  ERROR_ACTUALIZAR: 'Error al actualizar el almacén',
  ERROR_CARGAR: 'Error al cargar los almacenes',
} as const;

// ─────────────────────────────────────────────────────────────────────────────
// Mensajes de confirmación (solo para modales de confirmación)
// ─────────────────────────────────────────────────────────────────────────────
export const ALMACEN_MENSAJES_CONFIRMACION = {
  ELIMINAR_TITULO: '¿Eliminar almacén?',
  ELIMINAR_DESCRIPCION: (nombreAlmacen: string) => 
    `Se eliminará el almacén "${nombreAlmacen}". Esta acción no se puede deshacer.`,
} as const;

// ─────────────────────────────────────────────────────────────────────────────
// Textos de botones
// ─────────────────────────────────────────────────────────────────────────────
export const ALMACEN_TEXTOS_BOTONES = {
  ELIMINAR: 'Eliminar',
  CANCELAR: 'Cancelar',
  GUARDAR: 'Guardar',
  CONTINUAR: 'Continuar',
  NUEVO: 'Nuevo Almacén',
} as const;

// ─────────────────────────────────────────────────────────────────────────────
// Duraciones de toasts (en milisegundos)
// ─────────────────────────────────────────────────────────────────────────────
export const ALMACEN_TOAST_DURACION = {
  EXITO: 3000,
  ERROR: 5000,
  ADVERTENCIA: 4000,
} as const;

// ─────────────────────────────────────────────────────────────────────────────
// Configuraciones de modales
// ─────────────────────────────────────────────────────────────────────────────
export const ALMACEN_MODAL_CONFIG = {
  WIDTH_CONFIRMACION: '500px',
  WIDTH_FORMULARIO: '800px',
  STYLE_CLASS: 'custom-dialog-confirm',
} as const;
