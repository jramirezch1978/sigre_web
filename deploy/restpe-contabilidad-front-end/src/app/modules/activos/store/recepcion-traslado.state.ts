import { RecepcionTrasladoEntity } from '../domain/models/recepcion-traslado.entity';

export interface RecepcionTrasladoState {
  traslados:      RecepcionTrasladoEntity[];
  loadingObtener: boolean;
  errorObtener:   string | null;
}

export const initialRecepcionTrasladoState: RecepcionTrasladoState = {
  traslados:      [],
  loadingObtener: false,
  errorObtener:   null,
};
