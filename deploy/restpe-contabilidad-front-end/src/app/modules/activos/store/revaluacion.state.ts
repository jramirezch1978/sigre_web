import { RevaluacionEntity } from '../domain/models/revaluacion.entity';

export interface RevaluacionState {
  revaluaciones:  RevaluacionEntity[];
  loadingObtener: boolean;
  errorObtener:   string | null;
}

export const initialRevaluacionState: RevaluacionState = {
  revaluaciones:  [],
  loadingObtener: false,
  errorObtener:   null,
};
