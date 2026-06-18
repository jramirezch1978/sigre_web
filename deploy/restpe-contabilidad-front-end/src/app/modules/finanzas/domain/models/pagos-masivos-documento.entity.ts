export interface PagosMasivosDocumentoEntity {
  pmd_tipoDoc: string;
  pmd_serieNum: string;
  pmd_proveedor: string;
  pmd_fechaEmision: string;
  pmd_fechaVencimiento: string;
  pmd_moneda: string;
  pmd_montoTotal: number;
  pmd_montoPendiente: number;
  pmd_montoPagado: number;
  pmd_estado: string;
}
