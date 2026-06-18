/**
 * Entidad de dominio: Orden de Servicio.
 * Convención: orden_servicio_campo / det_orden_servicio_campo
 */
export interface ArticuloServicioEntity {
  det_orden_servicio_codigo:          string;
  det_orden_servicio_cantidad:        number;
  det_orden_servicio_descripcion:     string;
  det_orden_servicio_precio_unitario: number;
  det_orden_servicio_subtotal:        number;
  det_orden_servicio_impuestos:       number;
  det_orden_servicio_total:           number;
}

export interface OrdenServicioEntity {
  orden_servicio_numero:          string;
  orden_servicio_fecha_registro:  string;
  orden_servicio_fecha_entrega:   string;
  orden_servicio_proveedor:       string;
  /** Tipo de identificación del proveedor: 'RUC' | 'DNI' | 'CE' */
  orden_servicio_tipo_documento?:    string;
  /** Número de documento del proveedor */
  orden_servicio_numero_documento?:  string;
  /** Dirección fiscal del proveedor */
  orden_servicio_direccion_fiscal?:  string;
  /** Dirección de entrega de la orden */
  orden_servicio_direccion_entrega?: string;
  orden_servicio_almacen:         string;
  orden_servicio_sucursal:        string;
  orden_servicio_centro_costo?:   string;
  orden_servicio_moneda:          string;
  orden_servicio_tipo_cambio?:    string;
  orden_servicio_condicion_pago?: string;
  orden_servicio_total:           number;
  orden_servicio_estado:          string;
  orden_servicio_articulos?:      ArticuloServicioEntity[];
  [key: string]: any;
}
