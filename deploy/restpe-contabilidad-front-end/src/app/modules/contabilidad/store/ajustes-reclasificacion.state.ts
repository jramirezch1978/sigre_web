import { AjustesReclasificacionEntity } from '../domain/models/ajustes-reclasificacion.entity';

export interface AjustesReclasificacionState {
  data: AjustesReclasificacionEntity | null;
  isLoading: boolean;
  errorObtener: string | null;
}

export const AJUSTES_RECLASIFICACION_INITIAL_STATE: AjustesReclasificacionState = {
  data: null,
  isLoading: false,
  errorObtener: null,
};
