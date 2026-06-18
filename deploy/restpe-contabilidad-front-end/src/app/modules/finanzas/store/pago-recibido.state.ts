import { PagoRecibidoEntity } from '../domain/models/pago-recibido.entity';

export interface PagoRecibidoState {
  pagos: PagoRecibidoEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialPagoRecibidoState: PagoRecibidoState = {
  pagos: [],
  loadingObtener: false,
  errorObtener: null,
};
