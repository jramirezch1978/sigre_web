export interface PagoDetraccionEntity {
  pd_codigo: string;
  pd_fechapago: string;
  pd_RUCproveedor: string;
  pd_proveedor: string;
  pd_importe: number;
  pd_mediopago: string;
  pd_estado: 'Pend. pago' | 'Pagada' | 'Pend. constancia';
}
