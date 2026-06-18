import { ProcesosAjustesEntity } from '../domain/models/procesos-ajustes.entity';

export interface ProcesosAjustesState {
  data: ProcesosAjustesEntity | null;
  isLoading: boolean;
  errorObtener: string | null;
}

export const PROCESOS_AJUSTES_INITIAL_STATE: ProcesosAjustesState = {
  data: null,
  isLoading: false,
  errorObtener: null,
};
