import { PlanAbastecimientoEntity } from '../domain/models/plan-abastecimiento.entity';

/**
 * Estado del store de Aprovisionamiento
 */
export interface AprovisionamientoState {
  planes: PlanAbastecimientoEntity[];
  planSeleccionado: PlanAbastecimientoEntity | null;
  loading: boolean;
  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  loadingEliminar: boolean;
  error: string | null;
  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  errorEliminar: string | null;
}

export const initialAprovisionamientoState: AprovisionamientoState = {
  planes: [],
  planSeleccionado: null,
  loading: false,
  loadingObtener: false,
  loadingGuardar: false,
  loadingActualizar: false,
  loadingEliminar: false,
  error: null,
  errorObtener: null,
  errorGuardar: null,
  errorActualizar: null,
  errorEliminar: null,
};
