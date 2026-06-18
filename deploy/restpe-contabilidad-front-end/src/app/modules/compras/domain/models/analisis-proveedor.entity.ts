/**
 * Entidad de dominio: Análisis de Proveedor.
 * Convención: analisis_proveedor_campo
 */
export interface AnalisisProveedorDetalleItem {
  analisis_proveedor_codigo:       string;
  analisis_proveedor_razon_social: string;
  analisis_proveedor_sucursal:     string;
  montoAcumulado:                  number;
}

export class AnalisisProveedorEntity {
  constructor(
    public readonly analisis_proveedor_codigo:              string,
    public readonly analisis_proveedor_doc_fiscal:          string,
    public readonly analisis_proveedor_razon_social:        string,
    public readonly analisis_proveedor_tipo_documento:      string,
    public readonly analisis_proveedor_doc_emitidos:        number,
    public readonly analisis_proveedor_moneda:              string,
    public readonly analisis_proveedor_ultima_compra:       string,
    public readonly analisis_proveedor_sucursal:            string,
    public readonly analisis_proveedor_estado_contable:     string,
    public readonly analisis_proveedor_subtotal:            number,
    public readonly analisis_proveedor_impuestos:           number,
    public readonly analisis_proveedor_monto_total:         number,
    public readonly analisis_proveedor_porc_participacion:  number,
    public readonly analisis_proveedor_centro_costo:        string,
    public readonly analisis_proveedor_detalle?:            AnalisisProveedorDetalleItem[]
  ) {}
}
