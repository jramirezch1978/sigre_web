import { PagoDetraccionEntity } from '../domain/models/pago-detraccion.entity';

export interface PagoDetraccionState {
  detracciones: PagoDetraccionEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialPagoDetraccionState: PagoDetraccionState = {
  detracciones: [],
  loadingObtener: false,
  errorObtener: null,
};
