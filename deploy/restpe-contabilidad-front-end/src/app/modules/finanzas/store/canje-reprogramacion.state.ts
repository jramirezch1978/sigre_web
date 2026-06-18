import { CanjeReprogramacionEntity } from '../domain/models/canje-reprogramacion.entity';

export interface CanjeReprogramacionState {
  registros: CanjeReprogramacionEntity[];
  loadingObtener: boolean;
  loadingCanje: boolean;
  loadingReprogramar: boolean;
  errorObtener: string | null;
  errorCanje: string | null;
  errorReprogramar: string | null;
  resultCanje: { success: boolean } | null;
  resultReprogramar: { success: boolean } | null;
}

export const CANJE_REPROGRAMACION_INITIAL_STATE: CanjeReprogramacionState = {
  registros: [],
  loadingObtener: false,
  loadingCanje: false,
  loadingReprogramar: false,
  errorObtener: null,
  errorCanje: null,
  errorReprogramar: null,
  resultCanje: null,
  resultReprogramar: null,
};
