export interface GraficoMensualEntity {
  grafico_meses: string[];
  grafico_valores: number[];
  grafico_meta?: number;
}

export interface DashboardRrhhEntity {
  dashboard_rrhh_costo_laboral_venta: number;
  dashboard_rrhh_rotacion: number;
  dashboard_rrhh_propinas: number;
  dashboard_rrhh_ausentismo: number;
  dashboard_rrhh_horas_extra: number;
  dashboard_rrhh_personal_activo: number;
  dashboard_rrhh_grafico_costo_laboral: GraficoMensualEntity;
  dashboard_rrhh_grafico_propinas: GraficoMensualEntity;
  dashboard_rrhh_grafico_rotacion: GraficoMensualEntity;
  dashboard_rrhh_grafico_ausentismo: GraficoMensualEntity;
  dashboard_rrhh_grafico_horas_extra: GraficoMensualEntity;
}
