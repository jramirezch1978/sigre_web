import { ClonacionAsientosEntity } from '../domain/models/clonacion-asientos.entity';

/**
 * ClonacionAsientosState — Tipado del estado reactivo.
 */
export interface ClonacionAsientosState {
  data: ClonacionAsientosEntity;
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const DATA_VACIA_CLONACION_ASIENTOS: ClonacionAsientosEntity = {
  items: [],
};

export const initialClonacionAsientosState: ClonacionAsientosState = {
  data: DATA_VACIA_CLONACION_ASIENTOS,
  loadingObtener: false,
  errorObtener: null,
};
