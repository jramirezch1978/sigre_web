export interface CanjeReprogramacionEntity {
  canje_tipo_comprobante: string;
  canje_nro_documento: string;
  canje_doc_fiscal: string;
  canje_proveedor: string;
  canje_fecha_emision: string;
  canje_fecha_vencimiento: string;
  canje_monto_total: number;
  canje_monto_pendiente: number;
  canje_moneda: string;
  canje_centro_costo: string;
  canje_sucursal: string;
  canje_asiento: string;
  canje_estado: string;
}
