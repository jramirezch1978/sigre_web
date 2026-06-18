import { MovCuentasBancYCajasEntity } from '../domain/models/mov-cuentas-banc-y-cajas.entity';

export interface MovCuentasBancYCajasState {
  movimientos: MovCuentasBancYCajasEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialMovCuentasBancYCajasState: MovCuentasBancYCajasState = {
  movimientos: [],
  loadingObtener: false,
  errorObtener: null,
};
