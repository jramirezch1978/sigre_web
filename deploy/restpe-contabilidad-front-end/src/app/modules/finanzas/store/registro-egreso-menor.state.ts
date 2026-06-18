import { RegistroEgresoMenorEntity } from '../domain/models/registro-egreso-menor.entity';

export interface RegistroEgresoMenorState {
  movimientos: RegistroEgresoMenorEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialRegistroEgresoMenorState: RegistroEgresoMenorState = {
  movimientos: [],
  loadingObtener: false,
  errorObtener: null,
};
