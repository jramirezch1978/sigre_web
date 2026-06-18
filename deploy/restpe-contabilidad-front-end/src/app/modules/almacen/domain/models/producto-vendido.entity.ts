export interface ProductoVendidoEntity {
  producto_vendido_fecha: string;
  producto_vendido_codigo: string;
  producto_vendido_producto: string;
  producto_vendido_categoria: string;
  producto_vendido_almacen: string;
  producto_vendido_medida: string;
  producto_vendido_cantidad_vendida: number;
  producto_vendido_precio_unitario: number;
  producto_vendido_costo_unitario: number;
  producto_vendido_ingreso_total: number;
  producto_vendido_costo_total: number;
  producto_vendido_margen: number;
  producto_vendido_cliente_tipo: string;
  producto_vendido_vendedor_responsable: string;
  producto_vendido_estado: string;
}
