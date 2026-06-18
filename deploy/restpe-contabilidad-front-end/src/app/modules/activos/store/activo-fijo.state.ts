import { ActivoFijoEntity } from '../domain/models/activo-fijo.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface ActivoFijoState {
  activosFijos: ActivoFijoEntity[];
  activoSeleccionado: ActivoFijoEntity | null;

  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingEliminar: boolean;
  loadingActualizar: boolean;

  errorObtener: string | null;
  errorGuardar: string | null;
  errorEliminar: string | null;
  errorActualizar: string | null;

  resultGuardar: ApiResponse<ActivoFijoEntity> | null;
  resultEliminar: ApiResponse<boolean> | null;
  resultActualizar: ApiResponse<ActivoFijoEntity> | null;
}

export const initialActivoFijoState: ActivoFijoState = {
  activosFijos: [],
  activoSeleccionado: null,

  loadingObtener: false,
  loadingGuardar: false,
  loadingEliminar: false,
  loadingActualizar: false,

  errorObtener: null,
  errorGuardar: null,
  errorEliminar: null,
  errorActualizar: null,

  resultGuardar: null,
  resultEliminar: null,
  resultActualizar: null,
};
