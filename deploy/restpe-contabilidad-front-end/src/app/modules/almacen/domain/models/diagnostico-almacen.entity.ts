export interface DiagnosticoAlmacenEntity {
  diagnostico_codigo: string;
  diagnostico_almacen: string;
  diagnostico_ubicacion: string;
  diagnostico_responsable: string;
  diagnostico_valor_inventario: number;
  diagnostico_ocupacion: number;
  diagnostico_rotacion_inventario: number;
  diagnostico_dias_promedio_inventario: number;
  diagnostico_baja_rotacion: number;
  diagnostico_costo_almacenamiento: number;
  diagnostico_ultimo_cambio: string;
  diagnostico_condicion: string;
}
