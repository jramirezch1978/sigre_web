import { RegistroTrasladoEntity } from '../domain/models/registro-traslado.entity';

export interface RegistroTrasladoState {
  traslados:      RegistroTrasladoEntity[];
  loadingObtener: boolean;
  errorObtener:   string | null;
}

export const initialRegistroTrasladoState: RegistroTrasladoState = {
  traslados:      [],
  loadingObtener: false,
  errorObtener:   null,
};
