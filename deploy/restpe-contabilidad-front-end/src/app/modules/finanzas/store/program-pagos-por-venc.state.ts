import { ProgramPagosPorVencEntity } from '../domain/models/program-pagos-por-venc.entity';

export interface ProgramPagosPorVencState {
  pagos: ProgramPagosPorVencEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialProgramPagosPorVencState: ProgramPagosPorVencState = {
  pagos: [],
  loadingObtener: false,
  errorObtener: null,
};
