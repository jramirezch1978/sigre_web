export interface CuadreStockEntity {
  cuadre_almacen_codigo: string;
  cuadre_codigo: string;
  cuadre_unidad_medida: string;
  cuadre_descripcion: string;
  cuadre_fecha_corte: string | null;
  cuadre_stock_actual: number;
  cuadre_stock_recalculado: number;
  cuadre_diferencia: number;
  cuadre_estado: string;
}
