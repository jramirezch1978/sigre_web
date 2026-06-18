/**
 * Entidad de dominio: Aprobación de Traslado de Activos Fijos.
 * Convención de nombres: atr_campo (snake_case).
 */
export interface AprobacionTrasladoEntity {
  id?: string;
  atr_numero_traslado:    string;   // N° de traslado (TRA-001...)
  atr_fecha_solicitud:    string;   // Fecha de solicitud
  atr_solicitante:        string;   // Nombre del solicitante
  atr_origen:             string;   // Ubicación de origen
  atr_destino:            string;   // Ubicación de destino
  atr_estado:             'Pendiente' | 'Aprobado' | 'Rechazado';
  atr_activo?:            string;   // Activo involucrado
  atr_responsable_activo?: string;  // Responsable del activo
  atr_area_responsable?:  string;   // Área responsable
  atr_centro_costos?:     string;   // Centro de costos
  atr_motivo_traslado?:   string;   // Motivo del traslado
  atr_fecha_programada?:  string;   // Fecha programada de ejecución
  atr_observaciones?:     string;   // Observaciones
  atr_aprobacion?:        string;   // Persona que aprueba
  atr_fecha_aprobacion?:  string;   // Fecha de aprobación
  atr_ejecucion?:         string;   // Persona que ejecuta
  atr_fecha_ejecucion?:   string;   // Fecha de ejecución
}
