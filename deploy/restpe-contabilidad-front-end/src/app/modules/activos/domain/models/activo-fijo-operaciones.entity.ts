/**
 * Accesorio vinculado a un Activo Fijo.
 */
export interface AccesorioEntity {
  id?: string;
  activoFijoId: string;
  codigo: string;
  descripcion: string;
  valorAdquisicion?: number;
  estado?: string;
}

/**
 * Incidencia registrada sobre un Activo Fijo.
 */
export interface IncidenciaEntity {
  id?: string;
  activoFijoId: string;
  tipo: string;
  descripcion: string;
  fechaIncidencia?: string;
  costoReparacion?: number;
  estado?: string;
  observaciones?: string;
}

/**
 * Adaptación o mejora sobre un Activo Fijo.
 */
export interface AdaptacionEntity {
  id?: string;
  activoFijoId: string;
  descripcion: string;
  tipoAdaptacion?: string;
  fechaAdaptacion?: string;
  costoAdaptacion?: number;
  autorizadoPor?: string;
  estado?: string;
}

/**
 * Entrada del historial de cambios de un Activo Fijo.
 */
export interface HistorialActivoFijoEntity {
  id?: string;
  activoFijoId: string;
  tipo: string;
  descripcion?: string;
  usuario: string;
  fechaActualizacion: string;
}
