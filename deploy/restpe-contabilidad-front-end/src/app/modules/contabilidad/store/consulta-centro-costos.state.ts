import { ConsultaCentroCostosEntity } from '../domain/models/consulta-centro-costos.entity';

/**
 * ConsultaCentroCostosState — Tipado del estado reactivo.
 */
export interface ConsultaCentroCostosState {
  data: ConsultaCentroCostosEntity;
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const DATA_VACIA_CENTRO_COSTOS: ConsultaCentroCostosEntity = {
  items: [],
};

export const initialConsultaCentroCostosState: ConsultaCentroCostosState = {
  data: DATA_VACIA_CENTRO_COSTOS,
  loadingObtener: false,
  errorObtener: null,
};
