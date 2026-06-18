import { ResumenRangosEntity } from '../domain/models/resumen-rangos.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface ResumenRangosState {
  rangos:              ResumenRangosEntity[];
  rangoSeleccionado:   ResumenRangosEntity | null;

  loadingObtener:    boolean;
  loadingGuardar:    boolean;
  loadingActualizar: boolean;
  loadingEliminar:   boolean;

  errorObtener:    string | null;
  errorGuardar:    string | null;
  errorActualizar: string | null;
  errorEliminar:   string | null;

  resultGuardar:    ApiResponse | null;
  resultActualizar: ApiResponse | null;
  resultEliminar:   ApiResponse | null;
}

export const initialResumenRangosState: ResumenRangosState = {
  rangos:            [],
  rangoSeleccionado: null,

  loadingObtener:    false,
  loadingGuardar:    false,
  loadingActualizar: false,
  loadingEliminar:   false,

  errorObtener:    null,
  errorGuardar:    null,
  errorActualizar: null,
  errorEliminar:   null,

  resultGuardar:    null,
  resultActualizar: null,
  resultEliminar:   null,
};
