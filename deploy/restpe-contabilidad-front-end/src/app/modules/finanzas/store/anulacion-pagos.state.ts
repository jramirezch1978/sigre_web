import { AnulacionPagosEntity } from '../domain/models/anulacion-pagos.entity';

export interface AnulacionPagosState {
  registros: AnulacionPagosEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialAnulacionPagosState: AnulacionPagosState = {
  registros: [],
  loadingObtener: false,
  errorObtener: null,
};
