import { CotizacionEntity } from '../domain/models/cotizacion.entity';

/**
 * Estado del Store de Cotizaciones
 * Gestiona el estado global de las cotizaciones usando signals
 */
export interface CotizacionState {
  cotizaciones: CotizacionEntity[];
  cotizacionSeleccionada: CotizacionEntity | null;
  comparativo: any | null; // ComparativoCotizacionesEntity
  
  // Estados de carga
  loading: boolean;
  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  loadingEliminar: boolean;
  loadingComparativo: boolean;
  
  // Errores
  error: string | null;
  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  errorEliminar: string | null;
  errorComparativo: string | null;
}

/**
 * Estado inicial del Store
 */
export const initialCotizacionState: CotizacionState = {
  cotizaciones: [],
  cotizacionSeleccionada: null,
  comparativo: null,
  
  loading: false,
  loadingObtener: false,
  loadingGuardar: false,
  loadingActualizar: false,
  loadingEliminar: false,
  loadingComparativo: false,
  
  error: null,
  errorObtener: null,
  errorGuardar: null,
  errorActualizar: null,
  errorEliminar: null,
  errorComparativo: null,
};
