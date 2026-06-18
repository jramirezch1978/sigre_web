import { RegistroUitEntity } from '../domain/models/registro-uit.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

/**
 * RegistroUitState — Estado del signal store para Registro UIT.
 */
export interface RegistroUitState {
  items: RegistroUitEntity[];

  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;

  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;

  resultGuardar: ApiResponse<RegistroUitEntity> | null;
  resultActualizar: ApiResponse<RegistroUitEntity> | null;
}

export const initialRegistroUitState: RegistroUitState = {
  items: [],

  loadingObtener: false,
  loadingGuardar: false,
  loadingActualizar: false,

  errorObtener: null,
  errorGuardar: null,
  errorActualizar: null,

  resultGuardar: null,
  resultActualizar: null,
};
