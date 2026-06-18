import { GeneracionAsientosSiniestroEntity } from '../domain/models/generacion-asientos-siniestro.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface GeneracionAsientosSiniestroState {
  siniestros:              GeneracionAsientosSiniestroEntity[];
  siniestroSeleccionado:   GeneracionAsientosSiniestroEntity | null;

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

export const initialGeneracionAsientosSiniestroState: GeneracionAsientosSiniestroState = {
  siniestros:            [],
  siniestroSeleccionado: null,

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
