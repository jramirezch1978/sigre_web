import { ReglaAsignacionEntity } from '../domain/models/regla-asignacion.entity';

export interface ProduccionState {
  // Datos
  reglasAsignacion: ReglaAsignacionEntity[];

  // Loading states
  loadingReglasAsignacion: boolean;

  // Error states
  errorReglasAsignacion: string | null;
}

export const initialProduccionState: ProduccionState = {
  reglasAsignacion: [],
  loadingReglasAsignacion: false,
  errorReglasAsignacion: null,
};
