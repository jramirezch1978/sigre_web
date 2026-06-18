/**
 * Entidad de dominio: Factura No Compra.
 * Convención: factura_no_compra_campo
 */
export interface FacturaNoCompraEntity {
  factura_no_compra_codigo:                  string;
  factura_no_compra_fecha_registro:          string;
  factura_no_compra_doc_fiscal:              string;
  factura_no_compra_tipo_gasto:              string;
  factura_no_compra_proveedor:               string;
  factura_no_compra_vencimiento:             string;
  factura_no_compra_responsable:             string;
  factura_no_compra_monto_total:             number;
  factura_no_compra_estado:                  string;
  factura_no_compra_sucursal?:               string;
  factura_no_compra_centro_costo?:           string;
  factura_no_compra_moneda?:                 string;
  factura_no_compra_cuenta_contable?:        string;
  factura_no_compra_descripcion_detallada?:  string;
  factura_no_compra_archivo_adjunto?:        string;
  [key: string]: any;
}
