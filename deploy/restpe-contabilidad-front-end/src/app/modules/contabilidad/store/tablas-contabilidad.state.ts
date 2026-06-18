import { TablasContabilidadEntity } from '../domain/models/tablas-contabilidad.entity';

export interface TablasContabilidadState {
  data: TablasContabilidadEntity | null;
  isLoading: boolean;
  errorObtener: string | null;
}

export const TABLAS_CONTABILIDAD_INITIAL_STATE: TablasContabilidadState = {
  data: null,
  isLoading: false,
  errorObtener: null,
};
