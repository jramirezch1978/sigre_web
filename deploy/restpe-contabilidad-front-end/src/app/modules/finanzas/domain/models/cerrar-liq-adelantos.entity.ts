export interface CerrarLiqAdelantosEntity {
  /** Id real de la liquidación en el backend (necesario para cerrar). */
  id?: number;
  cla_num_liquidacion: string;
  cla_fecha_desembolso: string;
  cla_fecha_aprobacion: string;
  cla_fecha_cierre: string;
  cla_tipo_beneficiario: string;
  cla_beneficiario: string;
  cla_tipo_documento: string;
  cla_documento_beneficiario: string;
  cla_tipo_gasto: string;
  cla_centro_costo: string;
  cla_monto_adelantado: number;
  cla_total_gastado: number;
  cla_monto_gastado: number;
  cla_moneda: string;
  cla_moneda_id?: number;
  cla_responsable: string;
  cla_estado: string;
  cla_observaciones: string;
  cla_proveedor: string;
  cla_seleccionado?: boolean;
}
