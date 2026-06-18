export interface PaisVigenciaEntity {
  pais_vigencia_codigo: string;
  pais_vigencia_fecha_vigencia: string;
  pais_vigencia_remuneracion_soles: string;
  pais_vigencia_remuneracion_dolares: string;
  pais_vigencia_tipo_trabajador: string;
  pais_vigencia_estado: string;
  pais_vigencia_fecha_desde: string | Date;
  pais_vigencia_fecha_hasta: string | Date | null;
  pais_vigencia_remuneracion_soles_num: number;
  pais_vigencia_remuneracion_dolares_num: number;
  pais_vigencia_tipo_cambio: number;
  pais_vigencia_tipo_trabajador_value: string;
  pais_vigencia_estado_value: string;
  pais_vigencia_salario_ordinario?: string;
  pais_vigencia_bonificacion?: string;
  pais_vigencia_kpi?: string;
}
