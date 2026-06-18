export interface CentroCostoEntity {
  /** Código único del centro de costo (ej. CC-001) */
  centro_costo_codigo: string;
  /** Nombre descriptivo del centro de costo */
  centro_costo_nombre: string;
  /** Descripción detallada */
  centro_costo_descripcion?: string;
  /** Clasificación: Producción | Administrativos | Ventas | Servicios | Proyectos */
  centro_costo_clasificacion: string;
  /** Porcentaje de factor de distribución de costos (0 – 100) */
  centro_costo_factor: number;
  /** Código de cuenta contable de cargo */
  centro_costo_cuenta_cargo?: string;
  /** Código de cuenta contable de abono */
  centro_costo_cuenta_abono?: string;
  /** Usuario que registró el centro de costo */
  centro_costo_usuarior: string;
  /** Fecha de creación (ISO string o DD/MM/YYYY) */
  centro_costo_fecha_creacion: string;
  /** Fecha de última modificación */
  centro_costo_fecha_modificacion?: string;
  /** Estado: Activo | Inactivo */
  centro_costo_estado: string;
}
