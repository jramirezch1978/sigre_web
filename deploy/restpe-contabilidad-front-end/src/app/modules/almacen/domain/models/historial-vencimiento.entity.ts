export class HistorialVencimientoEntity {
  historial_vencimiento_fecha_registro: string;
  historial_vencimiento_codigo: string;
  historial_vencimiento_producto: string;
  historial_vencimiento_unidad_medida: string;
  historial_vencimiento_categoria: string;
  historial_vencimiento_almacen: string;
  historial_vencimiento_tipo_movimiento: string;
  historial_vencimiento_documento_origen: string;
  historial_vencimiento_entrada_salida: number;
  historial_vencimiento_saldo_final: number;
  historial_vencimiento_costo_unitario: number;
  historial_vencimiento_costo_total_movimiento: number;
  historial_vencimiento_costo_promedio: number;

  constructor(data: Partial<HistorialVencimientoEntity>) {
    this.historial_vencimiento_fecha_registro = data.historial_vencimiento_fecha_registro || '';
    this.historial_vencimiento_codigo = data.historial_vencimiento_codigo || '';
    this.historial_vencimiento_producto = data.historial_vencimiento_producto || '';
    this.historial_vencimiento_unidad_medida = data.historial_vencimiento_unidad_medida || '';
    this.historial_vencimiento_categoria = data.historial_vencimiento_categoria || '';
    this.historial_vencimiento_almacen = data.historial_vencimiento_almacen || '';
    this.historial_vencimiento_tipo_movimiento = data.historial_vencimiento_tipo_movimiento || '';
    this.historial_vencimiento_documento_origen = data.historial_vencimiento_documento_origen || '';
    this.historial_vencimiento_entrada_salida = data.historial_vencimiento_entrada_salida || 0;
    this.historial_vencimiento_saldo_final = data.historial_vencimiento_saldo_final || 0;
    this.historial_vencimiento_costo_unitario = data.historial_vencimiento_costo_unitario || 0;
    this.historial_vencimiento_costo_total_movimiento = data.historial_vencimiento_costo_total_movimiento || 0;
    this.historial_vencimiento_costo_promedio = data.historial_vencimiento_costo_promedio || 0;
  }
}
