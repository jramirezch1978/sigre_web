/**
 * Entidad de dominio: Registro de Traslados de Activos Fijos.
 * Representa cada solicitud de traslado entre sucursales / almacenes.
 * Convención de nombres: tabla_campo (snake_case).
 */
export interface RegistroTrasladoEntity {
  registro_traslado_codigo:         string;  // Código único (TRA-001…)
  registro_traslado_f_solicitud:    string;  // Fecha de solicitud YYYY-MM-DD
  registro_traslado_solicitante:    string;  // Nombre del solicitante
  registro_traslado_origen:         string;  // Sucursal / almacén de origen
  registro_traslado_destino:        string;  // Sucursal / almacén de destino
  registro_traslado_estado:         string;  // Pendiente | Aprobado | Rechazado | Recepcionado
  registro_traslado_motivo:         string;  // Motivo del traslado
  registro_traslado_observaciones?: string;  // Observaciones adicionales
  registro_traslado_f_programada?:  string;  // Fecha programada YYYY-MM-DD
  registro_traslado_aprobacion?:    string;  // Responsable de aprobación
  registro_traslado_f_aprobacion?:  string;  // Fecha de aprobación YYYY-MM-DD
  registro_traslado_ejecucion?:     string;  // Responsable de ejecución
  registro_traslado_f_ejecucion?:   string;  // Fecha de ejecución YYYY-MM-DD
  registro_traslado_activos?:       RegistroTrasladoActivoEntity[]; // Activos del traslado
}

/**
 * Activo fijo asociado a un traslado.
 */
export interface RegistroTrasladoActivoEntity {
  activo_fijo_codigo:        string;
  activo_fijo_descripcion:   string;
  activo_fijo_responsable?:  string;
  activo_fijo_centro_costos?: string;
}
