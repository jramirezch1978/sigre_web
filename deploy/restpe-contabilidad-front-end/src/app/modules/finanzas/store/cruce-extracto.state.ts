import { CruceExtractoEntity } from "../domain/models/cruce-extracto.entity";
import { MovimientoCruceEntity } from "../domain/models/movimiento-cruce.entity";

export interface CruceExtractoState {
  cruces: CruceExtractoEntity[];
  movimientos: MovimientoCruceEntity[];
  isLoading: boolean;
  error: string | null;
}

export const initialCruceExtractoState: CruceExtractoState = {
  cruces: [],
  movimientos: [],
  isLoading: false,
  error: null,
};
