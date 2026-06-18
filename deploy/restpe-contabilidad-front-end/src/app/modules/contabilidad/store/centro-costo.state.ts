import { CentroCostoEntity } from '../domain/models/centro-costo.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface CentroCostoState {
  centrosCosto: CentroCostoEntity[];
  centroCostoSeleccionado: CentroCostoEntity | null;

  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  loadingEliminar: boolean;

  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  errorEliminar: string | null;

  resultGuardar: ApiResponse<CentroCostoEntity> | null;
  resultActualizar: ApiResponse<CentroCostoEntity> | null;
  resultEliminar: ApiResponse<boolean> | null;
}

export const initialCentroCostoState: CentroCostoState = {
  centrosCosto: [],
  centroCostoSeleccionado: null,

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
