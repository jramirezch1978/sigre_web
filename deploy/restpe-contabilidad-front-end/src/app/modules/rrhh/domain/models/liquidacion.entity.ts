export interface LiquidacionEntity {
  liquidacion_codigo?: string;
  liquidacion_trabajador?: string;
  liquidacion_fecha_inicio?: string;
  liquidacion_estado?: string;
  liquidacion_sueldo_basico?: number;
  liquidacion_asignacion_familiar?: number;
  liquidacion_promedio_gratificacion?: number;
  liquidacion_fecha_cese?: string;
  liquidacion_tipo_cese?: string;
  liquidacion_cts_total?: number;
  liquidacion_gratificacion_total?: number;
  liquidacion_otros_beneficios?: number;
  liquidacion_vacaciones_total?: number;
  liquidacion_bonificacion_extraordinaria?: number;
  liquidacion_descuento_rr?: number;
  liquidacion_total_pagar?: number;
  liquidacion_observaciones?: string;
  aguinaldo?: number;
  bono14?: number;
  vacaciones?: number;
  indemnizacion?: number;
  trabajadorSelect?: string;
}
