/**
 * Entidad de dominio: Documento por Pagar Directo (DPD).
 * Convención: dpd_campo
 */
export interface DocumentoDirectoDetalleEntity {
  item?: number;
  descripcion: string;
  cantidad: number;
  precioUni: number;
  subtotal: number;
  monto?: number;
  impuestos?: string;
  conceptoFinancieroNombre?: string;
  conceptoFinancieroId?: number;
  centros_costo_id?: number;
  tiposImpuestoId?: number;
}

export interface DocumentoDirectoEntity {
  id?: number;
  dpd_codigo: string;
  dpd_tipo_documento?: string;
  dpd_doc_tipo_id?: number;
  dpd_serie: string;
  dpd_numero: string;
  dpd_proveedor: string;
  dpd_proveedor_id?: number;
  dpd_nro_documento: string;
  dpd_fecha_emision: string;
  dpd_fecha_vencimiento?: string;
  dpd_moneda?: string;
  dpd_total: number;
  dpd_estado: string;
  dpd_detalle?: DocumentoDirectoDetalleEntity[];
  [key: string]: any;
}
