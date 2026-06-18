import { CerrarLiqAdelantosEntity } from '../domain/models/cerrar-liq-adelantos.entity';

export interface CerrarLiqAdelantosState {
  liquidaciones: CerrarLiqAdelantosEntity[];
  loadingObtener: boolean;
  loadingActualizar: boolean;
  errorObtener: string | null;
  errorActualizar: string | null;
  actualizadoOk: boolean;
  mensajeExito: string | null;
}

export const initialCerrarLiqAdelantosState: CerrarLiqAdelantosState = {
  liquidaciones: [],
  loadingObtener: false,
  loadingActualizar: false,
  errorObtener: null,
  errorActualizar: null,
  actualizadoOk: false,
  mensajeExito: null,
};
