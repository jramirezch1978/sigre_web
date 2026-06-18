export class StockFechaEntity {
  public stock_fecha_codigo: string;
  public stock_fecha_producto: string;
  public stock_fecha_categoria: string;
  public stock_fecha_medida: string;
  public stock_fecha_ultimo_movimiento: string;
  public stock_fecha_almacen: string;
  public stock_fecha_stock_actual: number;
  public stock_fecha_estado: string;
  public stock_fecha_stock_disponible?: number;
  public stock_fecha_stock_comprometido?: number;
  public stock_fecha_valor_unitario?: number;
  public stock_fecha_valor_total?: number;

  constructor(data: Partial<StockFechaEntity>) {
    this.stock_fecha_codigo = data.stock_fecha_codigo || '';
    this.stock_fecha_producto = data.stock_fecha_producto || '';
    this.stock_fecha_categoria = data.stock_fecha_categoria || '';
    this.stock_fecha_medida = data.stock_fecha_medida || '';
    this.stock_fecha_ultimo_movimiento = data.stock_fecha_ultimo_movimiento || '';
    this.stock_fecha_almacen = data.stock_fecha_almacen || '';
    this.stock_fecha_stock_actual = data.stock_fecha_stock_actual || 0;
    this.stock_fecha_estado = data.stock_fecha_estado || '';
    this.stock_fecha_stock_disponible = data.stock_fecha_stock_disponible;
    this.stock_fecha_stock_comprometido = data.stock_fecha_stock_comprometido;
    this.stock_fecha_valor_unitario = data.stock_fecha_valor_unitario;
    this.stock_fecha_valor_total = data.stock_fecha_valor_total;
  }
}
