import { PatrimonioEntity, ReporteFinancieroEntity } from '../domain/models/reporte-financiero.entity';

export interface ReporteFinancieroState {
  situacionFinanciera: ReporteFinancieroEntity | null;
  estadoResultados: ReporteFinancieroEntity | null;
  flujoEfectivo: ReporteFinancieroEntity | null;
  cambiosPatrimonio: PatrimonioEntity | null;
  isLoading: boolean;
  errorObtener: string | null;
}

export const REPORTE_FINANCIERO_INITIAL_STATE: ReporteFinancieroState = {
  situacionFinanciera: null,
  estadoResultados: null,
  flujoEfectivo: null,
  cambiosPatrimonio: null,
  isLoading: false,
  errorObtener: null,
};
