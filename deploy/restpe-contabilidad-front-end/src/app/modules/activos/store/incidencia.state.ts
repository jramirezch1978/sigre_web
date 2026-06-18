import { IncidenciaEntity } from '../domain/models/incidencia.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

/**
 * Estado reactivo para el módulo de Incidencias.
 */
export interface IncidenciaState {
  incidencias: IncidenciaEntity[];
  incidenciaSeleccionada: IncidenciaEntity | null;

  // Flags de carga individuales por operación
  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  loadingEliminar: boolean;

  // Errores por operación
  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  errorEliminar: string | null;

  // Resultados por operación
  resultGuardar: ApiResponse | null;
  resultActualizar: ApiResponse | null;
  resultEliminar: ApiResponse | null;
}

export const initialIncidenciaState: IncidenciaState = {
  incidencias: [],
  incidenciaSeleccionada: null,

  loadingObtener: false,
  loadingGuardar: false,
  loadingActualizar: false,
  loadingEliminar: false,

  errorObtener: null,
  errorGuardar: null,
  errorActualizar: null,
  errorEliminar: null,

  resultGuardar: null,
  resultActualizar: null,
  resultEliminar: null,
};
