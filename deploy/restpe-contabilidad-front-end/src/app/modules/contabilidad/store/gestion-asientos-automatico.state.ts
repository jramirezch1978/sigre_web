import { GestionAsientosAutomaticoEntity } from '../domain/models/gestion-asientos-automatico.entity';

/**
 * GestionAsientosAutomaticoState — Tipado del estado reactivo.
 */
export interface GestionAsientosAutomaticoState {
  data: GestionAsientosAutomaticoEntity;
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const DATA_VACIA_GESTION_ASIENTOS_AUTO: GestionAsientosAutomaticoEntity = {
  items: [],
};

export const initialGestionAsientosAutomaticoState: GestionAsientosAutomaticoState = {
  data: DATA_VACIA_GESTION_ASIENTOS_AUTO,
  loadingObtener: false,
  errorObtener: null,
};
