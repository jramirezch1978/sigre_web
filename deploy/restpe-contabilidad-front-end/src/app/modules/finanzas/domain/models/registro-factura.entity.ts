export interface RegistroFacturaEntity {
  factura_tipo_doc: string;
  factura_nro_documento: string;
  factura_cliente: string;
  factura_sucursal: string;
  factura_dni: string;
  factura_tipo_doc_cliente: string;
  factura_fecha_emision: string;
  factura_fecha_vencimiento: string;
  factura_monto: number;
  factura_moneda: string;
  factura_asiento: string;
  factura_show_eye: boolean;
  factura_estado: string;
  factura_descripcion_servicio?: string;
  factura_tipo_cambio?: number | null;
  factura_centro_costo?: string;
  factura_cuenta_contable_ingreso?: string;
  factura_medio_cobro?: string;
  factura_observaciones?: string;
}
