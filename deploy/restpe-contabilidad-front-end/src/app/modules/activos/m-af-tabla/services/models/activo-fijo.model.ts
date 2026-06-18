/**
 * Modelo principal de Activo Fijo
 */
export interface ActivoFijo {
  id?: string;
  codigo?: string;
  nombreActivo?: string;
  descripcion?: string;
  clasificacion?: string;
  clase?: string;
  subclase?: string;
  marcaModelo?: string;
  proveedor?: string;
  documentoVinculado?: string;
  fechaAdquisicion?: Date | string;
  periodoContable?: string;
  moneda?: string;
  valorAdquisicion?: number;
  tasadecambio?: number;
  valorSoles?: number;
  valorDolares?: number;
  valorNeto?: number;
  valorNetoLibros?: number;
  vidaUtil?: number;
  estado?: string;
  estadoComplementario?: string;
  metodoDepreciacion?: string;
  responsableActivo?: string;
  usuarioAsignado?: string;
  centroCostos?: string;
  garantiaInicio?: Date | string;
  garantiaFin?: Date | string;
  ubicacion?: string;
  serie?: string;
  observaciones?: string;
}

/**
 * Modelo de Accesorio vinculado a un Activo Fijo
 */
export interface Accesorio {
  id?: string;
  activoFijoId: string;
  codigo: string;
  descripcion: string;
  valorAdquisicion?: number;
  estado?: string;
}

/**
 * Modelo de Incidencia registrada sobre un Activo Fijo
 */
export interface Incidencia {
  id?: string;
  activoFijoId: string;
  tipo: string;
  descripcion: string;
  fechaIncidencia?: Date | string;
  costoReparacion?: number;
  estado?: string;
  observaciones?: string;
}

/**
 * Modelo de Adaptación o mejora de un Activo Fijo
 */
export interface Adaptacion {
  id?: string;
  activoFijoId: string;
  descripcion: string;
  tipoAdaptacion?: string;
  fechaAdaptacion?: Date | string;
  costoAdaptacion?: number;
  autorizadoPor?: string;
  estado?: string;
}

/**
 * Entrada del historial de cambios de un Activo Fijo
 */
export interface HistorialActivoFijo {
  id?: string;
  activoFijoId: string;
  tipo: string;
  descripcion?: string;
  usuario: string;
  fechaActualizacion: Date | string;
}
