import { SeleccionarCuentaContableEntity } from '../domain/models/seleccionar-cuenta-contable.entity';

/**
 * SeleccionarCuentaContableState — Tipado del estado reactivo.
 */
export interface SeleccionarCuentaContableState {
  data: SeleccionarCuentaContableEntity;
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const DATA_VACIA_CUENTA_CONTABLE: SeleccionarCuentaContableEntity = {
  items: [],
};

export const initialSeleccionarCuentaContableState: SeleccionarCuentaContableState = {
  data: DATA_VACIA_CUENTA_CONTABLE,
  loadingObtener: false,
  errorObtener: null,
};
