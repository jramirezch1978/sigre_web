export interface ActualizacionProductoEntity {
  actualizacion_codigo: string;
  actualizacion_unidad_medida: string;
  actualizacion_descripcion: string;
  actualizacion_proveedor: string;
  actualizacion_precio_anterior: number;
  actualizacion_precio_ultima: number;
  actualizacion_diferencia: number;
  actualizacion_fecha_ultima: string;
  actualizacion_fecha_actualizacion: string;
  actualizacion_n_factura: string;
  actualizacion_estado: 'Pendiente' | 'Actualizado' | 'Revertido';
}
