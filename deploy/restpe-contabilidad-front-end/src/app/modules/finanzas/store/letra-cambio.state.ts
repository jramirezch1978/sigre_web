import { LetraCambioEntity } from '../domain/models/letra-cambio.entity';

export interface LetraCambioState {
  letras: LetraCambioEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
  loadingGuardar: boolean;
  errorGuardar: string | null;
  loadingActualizar: boolean;
  errorActualizar: string | null;
}

export const LETRA_CAMBIO_INITIAL_STATE: LetraCambioState = {
  letras: [],
  loadingObtener: false,
  errorObtener: null,
  loadingGuardar: false,
  errorGuardar: null,
  loadingActualizar: false,
  errorActualizar: null,
};
