/**
 * Cartera de Pagos (Tesorería). Cada fila representa un DOCUMENTO POR PAGAR
 * (finanzas.cuentas_pagar) que puede seleccionarse para pagar. El pago se registra
 * como un movimiento de caja/bancos (flag_tipo_transaccion='P') con una línea por
 * cada documento seleccionado.
 */
export interface AplicacionPagosEntity {
  /** Id real de la cuenta por pagar (para el detalle del pago: cntasPagarId). */
  id?: number;
  ap_proveedor_id?: number;
  ap_doc_tipo_id?: number;
  ap_tipoDoc: string;          // docTipoCodigo / docTipoNombre
  ap_serieNumDoc: string;      // serie-numero
  ap_proveedor: string;        // proveedorRazonSocial
  ap_fechaAnticipo: string;    // fechaEmision
  ap_fechaPago: string;        // fechaVencimiento
  ap_moneda: string;           // monedaCodigo
  ap_tipoCambio: number;
  ap_montoTotal: number;       // total
  ap_montoAnticipado: number;  // (no aplica; 0)
  ap_saldo?: number;           // saldo pendiente
  ap_medioPago: string;
  ap_ctaContablePago: string;
  ap_estado: string;           // flagEstado mapeado
  ap_observaciones: string;
  ap_numeroAsiento?: string;
  /** Selección para pago consolidado. */
  ap_seleccionado?: boolean;
}
