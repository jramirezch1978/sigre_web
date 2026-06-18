export interface PlanillaEntity {
  planilla_codigo: string;
  planilla_periodo: string;
  planilla_fecha_registro: string;
  planilla_sucursal: string;
  planilla_calculo_desde: string;
  planilla_calculo_hasta: string;
  planilla_estado: string;
  planilla_tipo_planilla?: string;
  planilla_periodicidad_pago?: string;
  planilla_empleados_codigos?: string[];
}