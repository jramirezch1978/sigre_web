export interface ConfiguracionProvisionesEntity {
  configuracion_provision_codigo: string;
  configuracion_provision_periodo_vigencia: string;
  configuracion_provision_fecha_inicio?: string;
  configuracion_provision_fecha_fin?: string;
  configuracion_provision_tipo_provision: string;
  configuracion_provision_regimen_laboral: string;
  configuracion_provision_centro_costo: string;
  configuracion_provision_periodicidad: string;
  configuracion_provision_estado: string;
  configuracion_provision_cuenta_gasto: string;
  configuracion_provision_cuenta_pasivo: string;
  configuracion_provision_descripcion?: string;
}
