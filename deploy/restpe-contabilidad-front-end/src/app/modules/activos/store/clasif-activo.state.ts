import { ClasifActivoEntity } from '../domain/models/clasif-activo.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

/**
 * Estado reactivo de Clasificación de Activos.
 * Centraliza loading, errores y datos para toda la operativa CRUD.
 */
export interface ClasifActivoState {
  clasifsActivo: ClasifActivoEntity[];
  clasifSeleccionada: ClasifActivoEntity | null;

  loadingObtener:    boolean;
  loadingGuardar:    boolean;
  loadingEliminar:   boolean;
  loadingActualizar: boolean;

  errorObtener:    string | null;
  errorGuardar:    string | null;
  errorEliminar:   string | null;
  errorActualizar: string | null;

  resultGuardar:    ApiResponse | null;
  resultEliminar:   ApiResponse | null;
  resultActualizar: ApiResponse | null;
}

export const initialClasifActivoState: ClasifActivoState = {
  clasifsActivo:     [],
  clasifSeleccionada: null,

  loadingObtener:    false,
  loadingGuardar:    false,
  loadingEliminar:   false,
  loadingActualizar: false,

  errorObtener:    null,
  errorGuardar:    null,
  errorEliminar:   null,
  errorActualizar: null,

  resultGuardar:    null,
  resultEliminar:   null,
  resultActualizar: null,
};
