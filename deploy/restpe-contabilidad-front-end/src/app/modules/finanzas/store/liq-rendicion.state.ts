import { LiqRendicionEntity } from '../domain/models/liq-rendicion.entity';

export interface LiqRendicionState {
  liquidaciones: LiqRendicionEntity[];
  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  guardadoOk: boolean;
  actualizadoOk: boolean;
}

export const initialLiqRendicionState: LiqRendicionState = {
  liquidaciones: [],
  loadingObtener: false,
  loadingGuardar: false,
  loadingActualizar: false,
  errorObtener: null,
  errorGuardar: null,
  errorActualizar: null,
  guardadoOk: false,
  actualizadoOk: false,
};
