/**
 * Entidad de Incidencia de Activo Fijo.
 * Representa un tipo de incidencia registrable sobre un activo.
 */
export interface IncidenciaEntity {
  id?: string;
  incidencia_codigo: string;
  incidencia_descripcion: string;
  incidencia_tipo_impacto: string;
  incidencia_gravedad: string;
  incidencia_cta_contable: string;
  incidencia_requiere_aval?: boolean;
  incidencia_estado: string;
  incidencia_observaciones?: string;
}
