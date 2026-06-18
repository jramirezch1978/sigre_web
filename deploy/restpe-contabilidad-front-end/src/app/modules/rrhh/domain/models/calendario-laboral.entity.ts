export interface CalendarioLaboralEntity {
  calendario_laboral_codigo: string;
  calendario_laboral_sucursal: string;
  calendario_laboral_fecha: string;
  calendario_laboral_tipo: string;
  calendario_laboral_dias_seleccionados: string[];
  calendario_laboral_canal?: string;
  calendario_laboral_detalle?: string;
  calendario_laboral_tipo_feriado?: string;
  calendario_laboral_frecuencia_feriado?: string;
  calendario_laboral_mes_fijo?: number | string;
  calendario_laboral_dia_fijo?: number | string;
  calendario_laboral_fecha_feriado?: string;
  calendario_laboral_descripcion: string;
  calendario_laboral_aplica_remuneracion: boolean;
  calendario_laboral_estado: string;
  calendario_laboral_hora_inicio?: string;
  calendario_laboral_hora_fin?: string;
  calendario_laboral_descanso?: string;
  calendario_laboral_tipo_jornada?: string;
  calendario_laboral_recargo_he?: string;
  calendario_laboral_regla_remuneracion?: string;
}
