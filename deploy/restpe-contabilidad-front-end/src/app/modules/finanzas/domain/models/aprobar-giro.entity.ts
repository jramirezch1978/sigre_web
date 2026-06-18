export interface AprobarGiroEntity {
  /** Id real de la solicitud de giro en el backend (necesario para aprobar/rechazar). */
  id?: number;
  ag_num_orden_giro: string;
  ag_fecha_solicitud: string;
  /** Campos reales que entrega el backend `pendientes-aprobacion`. */
  ag_solicitante_id?: number;
  ag_motivo?: string;
  ag_fecha_aprobacion?: string;
  ag_tipo_beneficiario?: string;
  ag_tipo_documento?: string;
  ag_documento_beneficiario?: string;
  ag_nombre_beneficiario?: string;
  ag_beneficiario: string;
  ag_documento_asociado: string;
  ag_banco: string;
  ag_cuenta_bancaria?: string;
  ag_moneda: string;
  ag_monto_giro: number;
  ag_tipo_cambio?: string;
  ag_forma_pago?: string;
  ag_fecha_programada_pago?: string;
  ag_centro_costo?: string;
  ag_sucursal?: string;
  ag_responsable: string;
  ag_aprobador?: string;
  ag_glosa_contable?: string;
  ag_motivo_rechazo?: string;
  ag_estado: string;
  ag_seleccionado?: boolean;
  ag_show_eye?: boolean;
}
