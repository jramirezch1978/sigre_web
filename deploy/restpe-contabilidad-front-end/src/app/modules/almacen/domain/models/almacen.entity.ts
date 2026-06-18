export interface AlmacenEntity {
  /** Id real del backend (necesario para actualizar/eliminar). Ausente al crear. */
  id?: number;
  /** Sucursal (tenant) dueña del almacén; el backend la exige al crear. */
  sucursalId?: number;
  /** Id del tipo de almacén en el backend (almacenTipoId). */
  almacen_tipo_id?: number;
  almacen_codigo: string;
  almacen_nombre: string;
  almacen_tipo: string;
  almacen_direccion: string;
  almacen_ciudad: string;
  almacen_responsable: string;
  almacen_capacidad: string;
  almacen_distrito: string;
  almacen_estado: string;
  almacen_fecha?: string | Date;
  almacen_fecha_creacion?: string | Date;
  almacen_observaciones?: string;
}
