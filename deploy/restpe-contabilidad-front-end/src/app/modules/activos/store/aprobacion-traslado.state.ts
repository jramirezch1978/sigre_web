import { AprobacionTrasladoEntity } from '../domain/models/aprobacion-traslado.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface AprobacionTrasladoState {
  traslados:               AprobacionTrasladoEntity[];
  trasladoSeleccionado:    AprobacionTrasladoEntity | null;

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

export const initialAprobacionTrasladoState: AprobacionTrasladoState = {
  traslados:            [],
  trasladoSeleccionado: null,

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
