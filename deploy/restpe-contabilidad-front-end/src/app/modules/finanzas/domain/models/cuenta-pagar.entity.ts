export interface CuentaPagarEntity {
  cpa_codigo: string;
  cpa_sucursal: string;
  cpa_proveedor: string;
  cpa_ruc: string;
  cpa_tipoDoc: string;
  cpa_nDoc: string;
  cpa_facAsoc?: string;
  cpa_centroC: string;
  cpa_fechaE: string;
  cpa_fechaV: string;
  cpa_moneda: string;
  cpa_tipoC: string;
  cpa_montoT: string;
  cpa_montoP: string;
  cpa_saldoP: string;
  cpa_cuentaC: string;
  cpa_numeroA: string;
  cpa_estado: 'Pagada' | 'Pendiente' | 'Vencida' | 'Parcial' | 'Anulado';
  cpa_tipoCambio: string;
}
