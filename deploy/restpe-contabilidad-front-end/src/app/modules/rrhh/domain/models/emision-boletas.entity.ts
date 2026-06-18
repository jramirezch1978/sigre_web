export interface EmisionBoletasEntity {
  planilla_codigo: string;
  planilla_periodo: string;
  planilla_desde: string;
  planilla_hasta: string;
  planilla_sucursal: string;
  planilla_centro_costos: string;
  planilla_num_trabajador: number;
  planilla_tipo_planilla: string;
  planilla_fecha_emision: string;
  planilla_estado: string;
  planilla_trabajador?: string;
  planilla_num_boleta?: string;
}
