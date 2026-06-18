import { ConsistenciaAsientoItem, ConsistenciaPreAsientoItem } from '../domain/models/reporte-validacion.entity';

/**
 * ReporteValidacionState — Estado centralizado del reporte de validación.
 * Cada tipo de reporte tiene su propio loading/error.
 */
export interface ReporteValidacionState {
  consistencia: ConsistenciaAsientoItem[];
  consistenciaPre: ConsistenciaPreAsientoItem[];
  asientosDes: ConsistenciaAsientoItem[];

  loadingConsistencia: boolean;
  loadingConsistenciaPre: boolean;
  loadingAsientosDes: boolean;

  errorConsistencia: string | null;
  errorConsistenciaPre: string | null;
  errorAsientosDes: string | null;
}

export const initialReporteValidacionState: ReporteValidacionState = {
  consistencia: [],
  consistenciaPre: [],
  asientosDes: [],

  loadingConsistencia: false,
  loadingConsistenciaPre: false,
  loadingAsientosDes: false,

  errorConsistencia: null,
  errorConsistenciaPre: null,
  errorAsientosDes: null,
};
