/**
 * Entidad de dominio: Nota de Crédito/Débito.
 * Convención: nota_credito_campo
 */
export interface NotaCreditoEntity {
  nota_credito_codigo: string;
  nota_credito_tipo: string;
  nota_credito_serie: string;
  nota_credito_numero: string;
  nota_credito_responsable: string;
  nota_credito_fecha_emision: string;
  nota_credito_fecha_registro: string;
  nota_credito_proveedor: string;
  nota_credito_factura_afectada: string;
  nota_credito_cuenta_contable: string;
  nota_credito_estado: string;
  nota_credito_moneda?: string;
  nota_credito_motivo_ajuste?: string;
  nota_credito_descripcion_detallada?: string;
  nota_credito_subtotal?: number;
  nota_credito_impuesto?: number;
  nota_credito_total_ajuste?: number;
  nota_credito_nro_documento?: string;
  nota_credito_detalle?: NotaCreditoDetalleItem[];
  [key: string]: any;
}

export interface NotaCreditoDetalleItem {
  nota_credito_codigo_Producto:  string;
  nombreProducto: string;
  cantEntregada: number;
  cantAjustada: number | null;
  costoValor: number;
}
