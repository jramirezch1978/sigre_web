import { AsignacionCajaChicaEntity } from '../domain/models/asignacion-caja-chica.entity';

export interface AsignacionCajaChicaState {
  asignaciones: AsignacionCajaChicaEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialAsignacionCajaChicaState: AsignacionCajaChicaState = {
  asignaciones: [],
  loadingObtener: false,
  errorObtener: null,
};
