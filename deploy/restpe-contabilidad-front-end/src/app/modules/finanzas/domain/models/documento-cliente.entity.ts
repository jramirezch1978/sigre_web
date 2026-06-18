export interface DocumentoClienteEntity {
  dc_sucursal: string;
  dc_fechaEmision: string;
  dc_cliente: string;
  dc_rucDni: string;
  dc_tipoDoc: string;
  dc_nroComprobante: string;
  dc_moneda: string;
  dc_tipoCambio: string;
  dc_montoTotal: number;
  dc_saldoPendiente: number;
  dc_observaciones: string;
  dc_formaPago: string;
  dc_vencimiento: string;
  dc_mora: string;
  dc_numeroAsiento: string;
  dc_estado: 'Pagado' | 'Vencido' | 'Pendiente' | 'Anulado';
}
