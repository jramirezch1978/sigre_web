import { ObligacionVencerEntity } from '../domain/models/obligacion-vencer.entity';

export interface ObligacionVencerState {
  obligaciones: ObligacionVencerEntity[];
  isLoading: boolean;
  error: string | null;
}

export const initialObligacionVencerState: ObligacionVencerState = {
  obligaciones: [],
  isLoading: false,
  error: null,
};
