import { ConsistenciaAsientosEntity } from '../domain/models/consistencia-asientos.entity';

export interface ConsistenciaAsientosState {
  items: ConsistenciaAsientosEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialConsistenciaAsientosState: ConsistenciaAsientosState = {
  items: [],
  loadingObtener: false,
  errorObtener: null,
};
