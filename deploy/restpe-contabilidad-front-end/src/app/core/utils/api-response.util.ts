import { ApiResponse } from '../../shared/models/api-response.model';

/**
 * @summary Obtiene el mensaje desde la respuesta de la API o usa un fallback
 * @description
 * Centraliza la lógica para extraer mensajes de respuestas de API.
 * Si la API no envía mensaje, usa el mensaje de fallback proporcionado.
 * 
 * @param response - Respuesta de la API que puede contener un mensaje
 * @param fallbackMessage - Mensaje a usar si la API no envía uno
 * @returns El mensaje a mostrar al usuario
 * 
 * @example
 * ```ts
 * const mensaje = obtenerMensajeConFallback(
 *   resultado, 
 *   ALMACEN_MENSAJES_FALLBACK.GUARDADO_DESCRIPCION
 * );
 * this.toast.success(mensaje);
 * ```
 */
export function obtenerMensajeConFallback(
  response: ApiResponse | null | undefined,
  fallbackMessage: string
): string {
  // Si no hay respuesta, usar fallback
  if (!response) {
    return fallbackMessage;
  }

  // Si la respuesta tiene mensaje, usarlo
  if (response.message && response.message.trim() !== '') {
    return response.message;
  }

  // Si no hay mensaje en la respuesta, usar fallback
  return fallbackMessage;
}

/**
 * @summary Extrae el mensaje de error desde la respuesta de la API o usa un fallback
 * @description
 * Similar a obtenerMensajeConFallback pero diseñado para errores.
 * Prioriza el campo 'error' sobre 'message' en la respuesta.
 * 
 * @param error - String de error o respuesta de API con error
 * @param fallbackMessage - Mensaje a usar si no hay error específico
 * @returns El mensaje de error a mostrar al usuario
 */
export function obtenerMensajeError(
  error: string | ApiResponse | null | undefined,
  fallbackMessage: string
): string {
  // Si es un string, devolverlo directamente
  if (typeof error === 'string' && error.trim() !== '') {
    return error;
  }

  // Si es un objeto ApiResponse
  if (error && typeof error === 'object') {
    // Priorizar el campo 'error'
    if ('error' in error && error.error && typeof error.error === 'string') {
      return error.error;
    }
    // Usar 'message' como alternativa
    if ('message' in error && error.message && typeof error.message === 'string') {
      return error.message;
    }
  }

  // Usar fallback si no hay mensaje específico
  return fallbackMessage;
}
