/**
 * @summary Entidad de dominio para Sucursal
 * @description Representa una sucursal en el sistema de configuración
 */
export interface SucursalEntity {
  sucursal_codigo: string;
  sucursal_nombre: string;
  sucursal_direccion: string;
  sucursal_ciudad: string;
  sucursal_fecha_creacion: string;
  sucursal_usuario_responsable: string;
  sucursal_estado: string;
}
