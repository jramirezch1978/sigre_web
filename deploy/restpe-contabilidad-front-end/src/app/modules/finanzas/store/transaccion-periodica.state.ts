import { TransaccionPeriodicaEntity } from '../domain/models/transaccion-periodica.entity';

export interface TransaccionPeriodicaState {
  transacciones: TransaccionPeriodicaEntity[];
  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  resultGuardar: { success: boolean } | null;
  resultActualizar: { success: boolean } | null;
}

export const initialTransaccionPeriodicaState: TransaccionPeriodicaState = {
  transacciones: [],
  loadingObtener: false,
  loadingGuardar: false,
  loadingActualizar: false,
  errorObtener: null,
  errorGuardar: null,
  errorActualizar: null,
  resultGuardar: null,
  resultActualizar: null,
};
