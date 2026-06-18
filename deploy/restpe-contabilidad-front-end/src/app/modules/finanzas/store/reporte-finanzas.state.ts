import { ReporteFinanzasEntity } from '../domain/models/reporte-finanzas.entity';

export interface ReporteFinanzasState {
  movimientos: ReporteFinanzasEntity[];
  isLoading: boolean;
  error: string | null;
}

export const initialReporteFinanzasState: ReporteFinanzasState = {
  movimientos: [],
  isLoading: false,
  error: null,
};
