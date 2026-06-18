export interface AsistenciaEntity {
  asistencia_nombre: string;
  asistencia_sucursal: string;
  asistencia_tipo_turno: string;
  asistencia_descripcion: string;
  asistencia_dias_trabajados: string;
  asistencia_dias_ausentes: string;
  asistencia_dias_tardanza: string;
  asistencia_horas_feriado: string;
  asistencia_horas_lt: string;
  asistencia_horas_ld: string;
  asistencia_total_hf: string;
  asistencia_descuento_hf: string;
  asistencia_total_ch: string;
  asistencia_total_costo_h2: string;
  asistencia_total_costo_h50?: string;
  asistencia_remuneracion: string;
  asistencia_porcentaje_asistencia: string;
}
