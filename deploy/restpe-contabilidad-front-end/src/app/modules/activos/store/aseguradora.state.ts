import { AseguradoraEntity } from '../domain/models/aseguradora.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface AseguradoraState {
  aseguradoras: AseguradoraEntity[];
  aseguradoraSeleccionada: AseguradoraEntity | null;

  loadingObtener:    boolean;
  loadingGuardar:    boolean;
  loadingEliminar:   boolean;
  loadingActualizar: boolean;

  errorObtener:    string | null;
  errorGuardar:    string | null;
  errorEliminar:   string | null;
  errorActualizar: string | null;

  resultGuardar:    ApiResponse<AseguradoraEntity> | null;
  resultEliminar:   ApiResponse<boolean> | null;
  resultActualizar: ApiResponse<AseguradoraEntity> | null;
}

export const initialAseguradoraState: AseguradoraState = {
  aseguradoras: [],
  aseguradoraSeleccionada: null,

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
