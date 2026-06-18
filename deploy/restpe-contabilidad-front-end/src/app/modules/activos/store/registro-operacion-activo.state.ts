import { RegistroOperacionActivoEntity } from '../domain/models/registro-operacion-activo.entity';

export interface RegistroOperacionActivoState {
  registros:      RegistroOperacionActivoEntity[];
  loadingObtener: boolean;
  errorObtener:   string | null;
}

export const initialRegistroOperacionActivoState: RegistroOperacionActivoState = {
  registros:      [],
  loadingObtener: false,
  errorObtener:   null,
};
