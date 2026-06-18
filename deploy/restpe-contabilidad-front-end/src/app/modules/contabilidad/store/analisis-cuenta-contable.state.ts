import { AnalisisCuentaContableEntity } from '../domain/models/analisis-cuenta-contable.entity';

/**
 * AnalisisCuentaContableState — Estado centralizado del análisis de cuenta contable.
 * Sólo lectura (sin operaciones de escritura).
 */
export interface AnalisisCuentaContableState {
  data: AnalisisCuentaContableEntity;
  loadingObtener: boolean;
  errorObtener: string | null;
}

const DATA_VACIA: AnalisisCuentaContableEntity = {
  items: [],
};

export const initialAnalisisCuentaContableState: AnalisisCuentaContableState = {
  data: DATA_VACIA,
  loadingObtener: false,
  errorObtener: null,
};
