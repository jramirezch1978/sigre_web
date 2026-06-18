export interface RecalculoPrecioEntity {
  recalculo_codigo: string;
  recalculo_unidad_medida: string;
  recalculo_descripcion: string;
  recalculo_stock_actual: number;
  recalculo_stock_recalculado: number;
  recalculo_diferencia: number;
  recalculo_estado: string;
}
