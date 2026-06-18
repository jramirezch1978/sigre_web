export interface ValorizacionProductoEntity {
  valorizacion_producto_codigo: string;
  valorizacion_producto_producto: string;
  valorizacion_producto_categoria: string;
  valorizacion_producto_medida: string;
  valorizacion_producto_ultimo_cambio: string;
  valorizacion_producto_almacen: string;
  valorizacion_producto_cantidad_stock: number;
  valorizacion_producto_metodo_valorizacion: string;
  valorizacion_producto_estado: string;
  valorizacion_producto_costo_unitario?: number;
  valorizacion_producto_valor_total_stock?: number;
  valorizacion_producto_moneda_local?: string;
  valorizacion_producto_moneda_corporativa?: string;
  ultCambios?: string;
  cantStock?: number;
  metodoValo?: string;
  costoUnitario?: number;
  valorTotalStock?: number;
  monedaLocal?: string;
  monedaCorporativa?: string;
}
