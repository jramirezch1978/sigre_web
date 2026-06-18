import { ConciliacionEntity } from '../domain/models/conciliacion.entity';

export interface ConciliacionState {
  conciliaciones: ConciliacionEntity[];
  isLoading: boolean;
  error: string | null;
}

export const initialConciliacionState: ConciliacionState = {
  conciliaciones: [],
  isLoading: false,
  error: null,
};
