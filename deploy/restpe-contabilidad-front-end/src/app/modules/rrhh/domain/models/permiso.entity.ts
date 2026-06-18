export interface PermisoEntity {
  permiso_codigo: string;
  permiso_trabajador: string;
  permiso_sucursal: string;
  permiso_centro_costo: string;
  permiso_tipo: string;
  permiso_motivo: string;
  permiso_tiempo_permiso: string;
  permiso_fecha_inicio?: string;
  permiso_fecha_fin?: string;
  permiso_hora_inicio?: string;
  permiso_hora_fin?: string;
  permiso_estado: string;
}
