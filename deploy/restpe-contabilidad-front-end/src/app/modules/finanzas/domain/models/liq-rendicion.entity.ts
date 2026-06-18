/** Línea de detalle de la liquidación (finanzas.liquidacion_det). */
export interface LiqRendicionDetalleLinea {
  item?: number;
  conceptoFinancieroId?: number;
  cntasPagarId?: number;
  cntasCobrarId?: number;
  importe?: number;
  flagRetencion?: string;
  importeRetenido?: number;
  // Solo para mostrar en la grilla:
  conceptoNombre?: string;
  cuentaPagarLabel?: string;
}

export interface LiqRendicionEntity {
  /** Id real de la liquidación en el backend (necesario para editar/anular). */
  id?: number;
  lr_num_liquidacion: string;
  lr_fecha_desembolso: string;
  lr_monto_gastado: number;
  lr_moneda: string;
  lr_estado: string;
  // Campos reales del backend (finanzas.liquidacion).
  lr_solicitud_giro_id?: number;
  lr_concepto_financiero_id?: number;
  lr_importe_neto?: number;
  lr_tasa_cambio?: number;
  lr_moneda_id?: number;
  lr_saldo?: number;
  lr_observacion?: string;
  lr_detalles?: LiqRendicionDetalleLinea[];
  // SOBRA: campos del mock sin respaldo directo en el backend (se conservan opcionales).
  lr_beneficiario?: string;
  lr_tipo_gasto?: string;
  lr_centro_costo?: string;
  lr_monto_adelantado?: number;
  lr_gastos?: any[];
  lr_seleccionado?: boolean;
  lr_fecha_aprobacion?: string;
  tipoBeneficiario?: string;
  observaciones?: string;
}
