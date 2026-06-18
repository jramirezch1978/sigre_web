import { OrdenGiroEntity } from '../domain/models/orden-giro.entity';

export interface OrdenGiroState {
  ordenes: OrdenGiroEntity[];
  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  guardadoOk: boolean;
  actualizadoOk: boolean;
}

export const initialOrdenGiroState: OrdenGiroState = {
  ordenes: [],
  loadingObtener: false,
  loadingGuardar: false,
  loadingActualizar: false,
  errorObtener: null,
  errorGuardar: null,
  errorActualizar: null,
  guardadoOk: false,
  actualizadoOk: false,
};
