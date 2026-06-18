import { OrdenServicioEntity } from '../domain/models/orden-servicio.entity';

/**
 * Estado del Store de Órdenes de Servicio
 * Gestiona el estado global de las órdenes usando signals
 */
export interface OrdenServicioState {
  ordenesServicio: OrdenServicioEntity[];
  ordenServicioSeleccionada: OrdenServicioEntity | null;
  
  // Estados de carga
  loading: boolean;
  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  loadingEliminar: boolean;
  
  // Errores
  error: string | null;
  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  errorEliminar: string | null;
}

/**
 * Estado inicial del Store
 */
export const initialOrdenServicioState: OrdenServicioState = {
  ordenesServicio: [],
  ordenServicioSeleccionada: null,
  
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
