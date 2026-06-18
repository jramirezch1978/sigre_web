/**
 * Entidad de dominio: Orden de Compra.
 * Convención: orden_compra_campo / det_orden_compra_campo
 */
export interface ArticuloEntity {
  det_orden_compra_codigo:          string;
  det_orden_compra_cantidad:        number;
  det_orden_compra_unidad:          string;
  det_orden_compra_descripcion:     string;
  det_orden_compra_precio_unitario: number;
  det_orden_compra_subtotal:        number;
  det_orden_compra_impuestos:       number;
  det_orden_compra_total:           number;
  articuloId?:                      number;
  unidadMedidaId?:                  number | null;
  tipoImpuesto?:                    string | null;
  tipoImpuestoId?:                  number | null;
  igvTasa?:                         number;
  percepcionTasa?:                  number;
  descuentoPorcentaje?:             number;
  almacenId?:                       number | null;
  centrosCostoId?:                  number | null;
  fechaEntrega?:                    string;
}

export interface OrdenCompraEntity {
  orden_compra_numero:            string;
  orden_compra_fecha_registro:    string;
  orden_compra_fecha_entrega:     string;
  orden_compra_proveedor:         string;
  /** Tipo de identificación del proveedor: 'RUC' | 'DNI' | 'CE' */
  documentoproveedor?:            string;
  /** Número de documento del proveedor (RUC, DNI, etc.) */
  documentoproveedorinput?:       string;
  /** Dirección fiscal del proveedor */
  direccionFiscal?:               string;
  /** Dirección de entrega de la orden */
  direccionEntrega?:              string;
  orden_compra_almacen:           string;
  orden_compra_sucursal:          string;
  orden_compra_centro_costo?:     string;
  orden_compra_moneda:            string;
  orden_compra_tipo_cambio?:      string;
  orden_compra_condicion_pago?:   string;
  observaciones?:                 string;
  flagImportacion?:               boolean;
  flagSolicitaDua?:               boolean;
  orden_compra_total:             number;
  orden_compra_estado:            string;
  orden_compra_articulos?:        ArticuloEntity[];
  [key: string]: any;
}
