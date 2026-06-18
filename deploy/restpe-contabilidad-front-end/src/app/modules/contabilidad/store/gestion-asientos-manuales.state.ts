import { AsientoManualItem } from '../domain/models/gestion-asientos-manual.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

/**
 * GestionAsientosManualesState — Tipado del estado reactivo.
 */
export interface GestionAsientosManualesState {
  asientos: AsientoManualItem[];
  asientoSeleccionado: AsientoManualItem | null;

  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  loadingAnular: boolean;

  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  errorAnular: string | null;

  resultGuardar: ApiResponse<AsientoManualItem> | null;
  resultActualizar: ApiResponse<AsientoManualItem> | null;
  resultAnular: ApiResponse<boolean> | null;
}

export const initialGestionAsientosManualesState: GestionAsientosManualesState = {
  asientos: [],
  asientoSeleccionado: null,

  loadingObtener: false,
  loadingGuardar: false,
  loadingActualizar: false,
  loadingAnular: false,

  errorObtener: null,
  errorGuardar: null,
  errorActualizar: null,
  errorAnular: null,

  resultGuardar: null,
  resultActualizar: null,
  resultAnular: null,
};
