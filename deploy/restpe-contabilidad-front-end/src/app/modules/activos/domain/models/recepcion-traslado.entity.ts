/**
 * Entidad de dominio: Recepción de Traslados de Activos Fijos.
 * Representa el registro de un traslado pendiente o procesado.
 * Convención de nombres: tabla_campo (snake_case).
 */
export interface RecepcionTrasladoEntity {
  traslado_codigo:          string;  // Código único del traslado (TR-001…)
  traslado_fecha_recepcion: string;  // Fecha formateada DD/MM/YYYY o '-'
  traslado_origen:          string;  // Sucursal / almacén de origen
  traslado_destino:         string;  // Sucursal / almacén de destino
  traslado_responsable:     string;  // Usuario responsable o '-'
  traslado_estado:          string;  // Pendiente | Aprobado | Rechazado
}
