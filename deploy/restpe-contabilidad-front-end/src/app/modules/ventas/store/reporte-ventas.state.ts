import { ReporteVentasEntity } from '../domain/models/reporte-ventas.entity';

export interface ReporteVentasState {
  registros: ReporteVentasEntity[];
  loading: boolean;
  error: string | null;
}

export const initialReporteVentasState: ReporteVentasState = {
  registros: [],
  loading: false,
  error: null,
};
