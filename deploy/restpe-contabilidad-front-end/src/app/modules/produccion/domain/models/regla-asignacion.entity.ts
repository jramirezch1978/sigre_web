export interface IProductoElaboradoEntity {
  producto_elaborado_codigo: string;
  producto_elaborado_nombre_producto: string;
  producto_elaborado_base_prorrateo: string;
  producto_elaborado_cantidad_total: number;
  producto_elaborado_monto_total: number;
  producto_elaborado_monto_unitario: number;
  producto_elaborado_monto_depreciacion: number;
  producto_elaborado_importe_asignado_gif: number;
  producto_elaborado_estado: string;
}

export interface ReglaAsignacionEntity {
  regla_asignacion_gif_codigo: string;
  regla_asignacion_gif_periodo_cont: string;
  regla_asignacion_gif_base_prorrateo: string;
  regla_asignacion_gif_cantidad_productos: number;
  regla_asignacion_gif_depreciacion: number;
  regla_asignacion_gif_fecha_creacion: string;
  regla_asignacion_gif_estado: string;
  regla_asignacion_gif_centro_costo?: string;
  regla_asignacion_gif_centro_costo_origen?: string;
  regla_asignacion_gif_cuenta_contable_origen?: string;
  regla_asignacion_gif_cuenta_contable_destino?: string;
  regla_asignacion_gif_monto_depreciacion?: number;
  regla_asignacion_gif_numero_asiento?: string;
  regla_asignacion_gif_porcentaje?: number;
  regla_asignacion_gif_productos_elaborados?: IProductoElaboradoEntity[];
}

