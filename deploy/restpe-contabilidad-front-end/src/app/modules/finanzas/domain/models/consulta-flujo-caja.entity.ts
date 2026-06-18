export interface ConsultaFlujoCajaEntity {
  cfc_razon_social: string;
  cfc_entidad_financiera: string;
  cfc_tipo_cuenta: string;
  cfc_moneda: string;
  cfc_saldo_actual: number;
  cfc_ingresos_programados: number;
  cfc_egresos_proyectados: number;
  cfc_flujo_neto: number;
  cfc_saldo_proyectado: number;
  cfc_fecha_proyeccion: string;
  cfc_sucursal: string;
  cfc_estado: string;
}
