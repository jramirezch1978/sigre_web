import { OrdenCompraEntity } from '../domain/models/orden-compra.entity';

/**
 * Estado del Store de Órdenes de Compra
 * Gestiona el estado global de las órdenes usando signals
 */
export interface OrdenCompraState {
  ordenesCompra: OrdenCompraEntity[];
  ordenCompraSeleccionada: OrdenCompraEntity | null;
  
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
export const initialOrdenCompraState: OrdenCompraState = {
  ordenesCompra: [],
  ordenCompraSeleccionada: null,
  
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
