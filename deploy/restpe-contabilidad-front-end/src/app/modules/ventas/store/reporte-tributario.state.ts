import { ReporteTributarioDetalleEntity, ReporteTributarioConsolidadoEntity } from '../domain/models/reporte-tributario.entity';

export interface ReporteTributarioState {
  ventas: ReporteTributarioDetalleEntity[];
  compras: ReporteTributarioDetalleEntity[];
  consolidado: ReporteTributarioConsolidadoEntity[];

  loadingVentas: boolean;
  loadingCompras: boolean;
  loadingConsolidado: boolean;

  errorVentas: string | null;
  errorCompras: string | null;
  errorConsolidado: string | null;
}

export const initialReporteTributarioState: ReporteTributarioState = {
  ventas: [],
  compras: [],
  consolidado: [],

  loadingVentas: false,
  loadingCompras: false,
  loadingConsolidado: false,

  errorVentas: null,
  errorCompras: null,
  errorConsolidado: null,
};
