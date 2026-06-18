import { CuentaVsSubcategoriaEntity } from '../domain/models/cuenta-vs-subcategoria.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface CuentaVsSubcategoriaState {
  items: CuentaVsSubcategoriaEntity[];
  itemSeleccionado: CuentaVsSubcategoriaEntity | null;

  loadingObtener: boolean;
  loadingActualizar: boolean;

  errorObtener: string | null;
  errorActualizar: string | null;

  resultActualizar: ApiResponse<CuentaVsSubcategoriaEntity> | null;
}

export const initialCuentaVsSubcategoriaState: CuentaVsSubcategoriaState = {
  items: [],
  itemSeleccionado: null,

  loadingObtener: false,
  loadingActualizar: false,

  errorObtener: null,
  errorActualizar: null,

  resultActualizar: null,
};
