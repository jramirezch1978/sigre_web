import { AsignacionRatiosEntity } from '../domain/models/asignacion-ratios.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface AsignacionRatiosState {
  asignaciones:            AsignacionRatiosEntity[];
  asignacionSeleccionada:  AsignacionRatiosEntity | null;

  loadingObtener:    boolean;
  loadingGuardar:    boolean;
  loadingActualizar: boolean;
  loadingEliminar:   boolean;

  errorObtener:    string | null;
  errorGuardar:    string | null;
  errorActualizar: string | null;
  errorEliminar:   string | null;

  resultGuardar:    ApiResponse | null;
  resultActualizar: ApiResponse | null;
  resultEliminar:   ApiResponse | null;
}

export const initialAsignacionRatiosState: AsignacionRatiosState = {
  asignaciones:            [],
  asignacionSeleccionada:  null,

  loadingObtener:    false,
  loadingGuardar:    false,
  loadingActualizar: false,
  loadingEliminar:   false,

  errorObtener:    null,
  errorGuardar:    null,
  errorActualizar: null,
  errorEliminar:   null,

  resultGuardar:    null,
  resultActualizar: null,
  resultEliminar:   null,
};
