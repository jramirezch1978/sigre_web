import { OrdenCompraEntity } from '../domain/models/orden-compra.entity';

/**
 * Estado del flujo de Aprobación de Compras
 */
export interface AprobarCompraState {
  ordenesPendientes: OrdenCompraEntity[];
  ordenSeleccionada: OrdenCompraEntity | null;
  filasSeleccionadas: OrdenCompraEntity[];

  // Loading flags
  loading: boolean;
  loadingObtener: boolean;
  loadingAprobar: boolean;
  loadingRechazar: boolean;
  loadingRetornar: boolean;

  // Error flags
  error: string | null;
  errorObtener: string | null;
  errorAprobar: string | null;
  errorRechazar: string | null;
  errorRetornar: string | null;
}

export const initialAprobarCompraState: AprobarCompraState = {
  ordenesPendientes: [],
  ordenSeleccionada: null,
  filasSeleccionadas: [],

  loading: false,
  loadingObtener: false,
  loadingAprobar: false,
  loadingRechazar: false,
  loadingRetornar: false,

  error: null,
  errorObtener: null,
  errorAprobar: null,
  errorRechazar: null,
  errorRetornar: null
};
