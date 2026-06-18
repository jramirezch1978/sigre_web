import { NotaCreditoEntity } from '../domain/models/nota-credito.entity';

/**
 * Estado del store de Notas de Crédito/Débito - Application Layer
 */
export interface NotaCreditoState {
  notas: NotaCreditoEntity[];
  notaSeleccionada: NotaCreditoEntity | null;
  notaActual: NotaCreditoEntity | null;
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

export const initialNotaCreditoState: NotaCreditoState = {
  notas: [],
  notaSeleccionada: null,
  notaActual: null,
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
