export interface ObligacionVencerEntity {
  ov_sucursal: string;
  ov_proveedor: string;
  ov_ruc: string;
  ov_tipoDoc: string;
  ov_nroDoc: string;
  ov_fechaEmision: string;
  ov_moneda: string;
  ov_tipoCambio: string;
  ov_montoTotal: number;
  ov_saldoPendiente: number;
  ov_vencimiento: string;
  ov_venceEn: string;
  ov_mora: string;
  ov_numeroAsiento: string;
  ov_observaciones: string;
  ov_estado: 'Por vencer' | 'Vencida';
}
