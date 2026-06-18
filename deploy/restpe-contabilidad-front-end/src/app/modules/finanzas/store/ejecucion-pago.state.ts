import { EjecucionPagoEntity } from '../domain/models/ejecucion-pago.entity';

export interface EjecucionPagoState {
  pagos: EjecucionPagoEntity[];
  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingAnular: boolean;
  errorObtener: string | null;
  errorGuardar: string | null;
  errorAnular: string | null;
  guardadoOk: boolean;
  anuladoOk: boolean;
}

export const initialEjecucionPagoState: EjecucionPagoState = {
  pagos: [],
  loadingObtener: false,
  loadingGuardar: false,
  loadingAnular: false,
  errorObtener: null,
  errorGuardar: null,
  errorAnular: null,
  guardadoOk: false,
  anuladoOk: false,
};
