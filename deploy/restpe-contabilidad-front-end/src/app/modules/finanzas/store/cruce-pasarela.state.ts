import { CrucePasarelaEntity } from '../domain/models/cruce-pasarela.entity';
import { MovimientoPasarelaEntity } from '../domain/models/movimiento-pasarela.entity';

export interface CrucePasarelaState {
  cruces: CrucePasarelaEntity[];
  movimientos: MovimientoPasarelaEntity[];
  isLoading: boolean;
  error: string | null;
}

export const initialCrucePasarelaState: CrucePasarelaState = {
  cruces: [],
  movimientos: [],
  isLoading: false,
  error: null,
};
