export interface MovimientoCuadreStockEntity {
  mov_almacen_codigo: string;
  mov_producto_codigo: string;
  mov_fecha: string;
  mov_entrada: number | null;
  mov_salida: number | null;
  mov_stock: number;
  mov_unidad_medida: string;
  mov_documento: string;
  mov_observacion: string;
}
