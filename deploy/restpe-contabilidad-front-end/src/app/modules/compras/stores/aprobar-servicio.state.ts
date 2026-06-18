import { OrdenServicioEntity } from '../domain/models/orden-servicio.entity';

/**
 * Estado del flujo de Aprobación de Servicios
 */
export interface AprobarServicioState {
  ordenesPendientes: OrdenServicioEntity[];
  ordenSeleccionada: OrdenServicioEntity | null;
  filasSeleccionadas: OrdenServicioEntity[];

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

export const initialAprobarServicioState: AprobarServicioState = {
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
