import { CuentaPagarEntity } from '../domain/models/cuenta-pagar.entity';

export interface CuentaPagarState {
  facturas: CuentaPagarEntity[];
  isLoading: boolean;
  error: string | null;
}

export const initialCuentaPagarState: CuentaPagarState = {
  facturas: [],
  isLoading: false,
  error: null,
};
