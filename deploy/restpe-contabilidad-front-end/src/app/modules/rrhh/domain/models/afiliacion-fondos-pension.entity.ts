export interface AfiliacionFondosPensionDatosCompletosEntity {
  afiliacion_fondo_pension_trabajador: string;
  afiliacion_fondo_pension_dc_sucursal: string;
  afiliacion_fondo_pension_dc_centro_costo: string;
  afiliacion_fondo_pension_dc_fondo: string;
  afiliacion_fondo_pension_dc_franquicia: string;
  afiliacion_fondo_pension_dc_beneficios_asociados: string[];
  afiliacion_fondo_pension_estado: string;
  afiliacion_fondo_pension_retenciones: number[];
  afiliacion_fondo_pension_dc_monto_quinta: string;
  afiliacion_fondo_pension_dc_monto_cuarta: string;
  afiliacion_fondo_pension_dc_tipo_fondo: string;
  afiliacion_fondo_pension_dc_afp_afiliada: string;
  afiliacion_fondo_pension_dc_calculo_monto: string;
  afiliacion_fondo_pension_dc_porcentaje: string;
  afiliacion_fondo_pension_dc_concepto_desc: string;
  afiliacion_fondo_pension_dc_monto_otro_desc: string;
  afiliacion_fondo_pension_dc_aportes_empleador: number[];
  afiliacion_fondo_pension_dc_empleador_essalud: string;
  afiliacion_fondo_pension_dc_porcentaje_essalud: string;
  afiliacion_fondo_pension_dc_entidad_salud_eps: string;
  afiliacion_fondo_pension_dc_porcentaje_eps: string;
  afiliacion_fondo_pension_dc_entidad_salud_scrt: string;
  afiliacion_fondo_pension_dc_porcentaje_scrt: string;
}

export interface AfiliacionFondosPensionEntity {
  afiliacion_fondo_pension_codigo: string;
  afiliacion_fondo_pension_trabajador: string;
  afiliacion_fondo_pension_contrato_asociado: string;
  afiliacion_fondo_pension_beneficio_asociado: string;
  afiliacion_fondo_pension_retenciones: string;
  afiliacion_fondo_pension_aportes: string;
  afiliacion_fondo_pension_fecha: string;
  afiliacion_fondo_pension_estado: string;
  afiliacion_fondo_pension_datos_completos: AfiliacionFondosPensionDatosCompletosEntity;
}
