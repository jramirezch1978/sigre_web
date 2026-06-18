/**
 * Entidad de dominio: Factura de Proveedor.
 * Convención: factura_proveedor_campo
 */
export interface FacturaProveedorDetalleEntity {
  factura_proveedor_codigo: string;
  cantidad: number;
  descripcion: string;
  precioUni: number;
  subtotal: number;
  impuestos: string;
  total:                           number;
}

export interface FacturaProveedorEntity {
  factura_proveedor_codigo: string;
  factura_proveedor_nro_comprobante: string;
  factura_proveedor_tipo: string;
  factura_proveedor_proveedor: string;
  factura_proveedor_fecha_emision: string;
  factura_proveedor_fecha_registro: string;
  factura_proveedor_vencimiento: string;
  factura_proveedor_monto_total: number;
  factura_proveedor_moneda: string;
  factura_proveedor_responsable: string;
  factura_proveedor_orden_asociada: string;
  factura_proveedor_estado: string;
  // Campos para formulario
  factura_proveedor_tipo_documento?: string;
  factura_proveedor_nro_documento?: string;
  factura_proveedor_condicion_pago?: string;
  factura_proveedor_tipo_cambio?: string;
  factura_proveedor_cuenta_contable?: string;
  factura_proveedor_orden_asociada_activa?: boolean;
  factura_proveedor_tipo_orden?: string;
  factura_proveedor_regimen_recaudacion?: string;
  factura_proveedor_tipo_act_fiscal?: string;
  factura_proveedor_nro_detraccion?: string;
  factura_proveedor_fecha_detraccion?: string;
  factura_proveedor_monto_detraccion?: string;
  // Detalle de productos
  factura_proveedor_detalle?: FacturaProveedorDetalleEntity[];
  [key: string]: any;
}
