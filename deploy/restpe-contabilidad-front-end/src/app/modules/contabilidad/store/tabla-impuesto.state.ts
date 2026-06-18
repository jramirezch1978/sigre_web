import { TablaImpuestoEntity } from '../domain/models/tabla-impuesto.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface TablaImpuestoState {
  items: TablaImpuestoEntity[];

  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;

  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;

  resultGuardar: ApiResponse<TablaImpuestoEntity> | null;
  resultActualizar: ApiResponse<TablaImpuestoEntity> | null;
}

export const initialTablaImpuestoState: TablaImpuestoState = {
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
