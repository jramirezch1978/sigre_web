import { AplicacionPagosEntity } from '../domain/models/aplicacion-pagos.entity';
import { AplicacionPagosPlanillaEntity } from '../domain/models/aplicacion-pagos-planilla.entity';
import { AplicacionPagosTrabajadorEntity } from '../domain/models/aplicacion-pagos-trabajador.entity';

export interface AplicacionPagosState {
  registros: AplicacionPagosEntity[];
  planillas: AplicacionPagosPlanillaEntity[];
  trabajadores: AplicacionPagosTrabajadorEntity[];
  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  loadingPlanillas: boolean;
  loadingTrabajadores: boolean;
  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  errorPlanillas: string | null;
  errorTrabajadores: string | null;
  guardadoOk: boolean;
  actualizadoOk: boolean;
}

export const initialAplicacionPagosState: AplicacionPagosState = {
  registros: [],
  planillas: [],
  trabajadores: [],
  loadingObtener: false,
  loadingGuardar: false,
  loadingActualizar: false,
  loadingPlanillas: false,
  loadingTrabajadores: false,
  errorObtener: null,
  errorGuardar: null,
  errorActualizar: null,
  errorPlanillas: null,
  errorTrabajadores: null,
  guardadoOk: false,
  actualizadoOk: false,
};
