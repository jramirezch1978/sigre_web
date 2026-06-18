import { AprobarGiroEntity } from '../domain/models/aprobar-giro.entity';

export interface AprobarGiroState {
  ordenes: AprobarGiroEntity[];
  loadingObtener: boolean;
  loadingActualizar: boolean;
  errorObtener: string | null;
  errorActualizar: string | null;
  actualizadoOk: boolean;
  mensajeExito: string | null;
}

export const initialAprobarGiroState: AprobarGiroState = {
  ordenes: [],
  loadingObtener: false,
  loadingActualizar: false,
  errorObtener: null,
  errorActualizar: null,
  actualizadoOk: false,
  mensajeExito: null,
};
