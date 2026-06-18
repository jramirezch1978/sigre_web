import { CuentasCorrienteEntity } from '../domain/models/cuentas-corriente.entity';

/**
 * CuentasCorrienteState — Tipado del estado reactivo.
 */
export interface CuentasCorrienteState {
  data: CuentasCorrienteEntity;
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const DATA_VACIA: CuentasCorrienteEntity = {
  items: [],
};

export const initialCuentasCorrienteState: CuentasCorrienteState = {
  data: DATA_VACIA,
  loadingObtener: false,
  errorObtener: null,
};
