export interface PagoRecibidoEntity {
  pago_codigo: string;
  pago_tipo_doc: string;
  pago_nro_doc: string;
  pago_fecha_emision: string;
  pago_fecha_vencimiento: string;
  pago_moneda: string;
  pago_tipo_cambio: string;
  pago_monto_total: string;
  pago_monto_pendiente: string;
  pago_cuenta_contable: string;
  pago_nro_asiento: string;
  pago_estado: string;
}
