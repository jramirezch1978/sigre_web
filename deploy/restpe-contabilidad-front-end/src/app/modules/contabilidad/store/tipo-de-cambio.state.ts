import { TipoDeCambioEntity } from '../domain/models/tipo-de-cambio.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface TipoDeCambioState {
  items: TipoDeCambioEntity[];

  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  loadingEliminar: boolean;

  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  errorEliminar: string | null;

  resultGuardar: ApiResponse<TipoDeCambioEntity> | null;
  resultActualizar: ApiResponse<TipoDeCambioEntity> | null;
  resultEliminar: ApiResponse<boolean> | null;
}

export const initialTipoDeCambioState: TipoDeCambioState = {
  items: [],

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
