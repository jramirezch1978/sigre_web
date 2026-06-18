import { DetraccionEntity } from '../domain/models/detraccion.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface DetraccionState {
  detracciones: DetraccionEntity[];
  detraccionSeleccionada: DetraccionEntity | null;

  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  loadingEliminar: boolean;

  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  errorEliminar: string | null;

  resultGuardar: ApiResponse<DetraccionEntity> | null;
  resultActualizar: ApiResponse<DetraccionEntity> | null;
  resultEliminar: ApiResponse<boolean> | null;
}

export const initialDetraccionState: DetraccionState = {
  detracciones: [],
  detraccionSeleccionada: null,

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
