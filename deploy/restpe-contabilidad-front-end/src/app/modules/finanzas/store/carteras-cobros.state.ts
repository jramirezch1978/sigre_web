import { CarterasCobrosEntity } from '../domain/models/carteras-cobros.entity';

export interface CarterasCobrosState {
  cobros: CarterasCobrosEntity[];
  loadingObtener: boolean;
  loadingActualizar: boolean;
  errorObtener: string | null;
  errorActualizar: string | null;
  actualizadoOk: boolean;
}

export const initialCarterasCobrosState: CarterasCobrosState = {
  cobros: [],
  loadingObtener: false,
  loadingActualizar: false,
  errorObtener: null,
  errorActualizar: null,
  actualizadoOk: false,
};
