import { CondicionPagoEntity } from '../domain/models/condicion-pago.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface CondicionPagoState {
  condicionesPago: CondicionPagoEntity[];
  condicionSeleccionada: CondicionPagoEntity | null;

  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingEliminar: boolean;
  loadingActualizar: boolean;

  errorObtener: string | null;
  errorGuardar: string | null;
  errorEliminar: string | null;
  errorActualizar: string | null;

  resultGuardar: ApiResponse<CondicionPagoEntity> | null;
  resultEliminar: ApiResponse<boolean> | null;
  resultActualizar: ApiResponse<CondicionPagoEntity> | null;
}

export const initialCondicionPagoState: CondicionPagoState = {
  condicionesPago: [],
  condicionSeleccionada: null,

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
  resultActualizar: null
};
