import { LiqRendicionEntity } from '../domain/models/liq-rendicion.entity';

export interface AprobarLiqGastosState {
  liquidaciones: LiqRendicionEntity[];
  loadingObtener: boolean;
  loadingActualizar: boolean;
  errorObtener: string | null;
  errorActualizar: string | null;
  actualizadoOk: boolean;
  mensajeExito: string | null;
}

export const initialAprobarLiqGastosState: AprobarLiqGastosState = {
  liquidaciones: [],
  loadingObtener: false,
  loadingActualizar: false,
  errorObtener: null,
  errorActualizar: null,
  actualizadoOk: false,
  mensajeExito: null,
};
