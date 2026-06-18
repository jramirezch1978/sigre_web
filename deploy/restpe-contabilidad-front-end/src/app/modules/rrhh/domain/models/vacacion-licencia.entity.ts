export interface VacacionLicenciaEntity {
  vacacion_licencia_codigo: string;
  vacacion_licencia_trabajador: string;
  vacacion_licencia_sucursal: string;
  vacacion_licencia_centro_costo: string;
  vacacion_licencia_tipo: string;
  vacacion_licencia_subtipo: string;
  vacacion_licencia_subtipo_subsidio?: string;
  vacacion_licencia_dias_solicitados: string;
  vacacion_licencia_fecha_inicio: string;
  vacacion_licencia_fecha_fin: string;
  vacacion_licencia_motivo: string;
  vacacion_licencia_estado: string;
}
