import { ReporteTesoreriaEntity } from '../domain/models/reporte-tesoreria.entity';

export interface ReporteTesoreriaState {
  movimientos: ReporteTesoreriaEntity[];
  isLoading: boolean;
  error: string | null;
}

export const initialReporteTesoreriaState: ReporteTesoreriaState = {
  movimientos: [],
  isLoading: false,
  error: null,
};
