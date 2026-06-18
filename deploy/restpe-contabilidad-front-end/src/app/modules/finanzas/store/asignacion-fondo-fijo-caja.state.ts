import { AsignacionFondoFijoCajaEntity } from '../domain/models/asignacion-fondo-fijo-caja.entity';

export interface AsignacionFondoFijoCajaState {
  asignaciones: AsignacionFondoFijoCajaEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialAsignacionFondoFijoCajaState: AsignacionFondoFijoCajaState = {
  asignaciones: [],
  loadingObtener: false,
  errorObtener: null,
};
