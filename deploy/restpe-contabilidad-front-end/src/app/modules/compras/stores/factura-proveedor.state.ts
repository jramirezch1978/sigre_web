import { FacturaProveedorEntity } from '../domain/models/factura-proveedor.entity';

/**
 * Estado del store de Facturas de Proveedor - Application Layer
 */
export interface FacturaProveedorState {
  facturas: FacturaProveedorEntity[];
  facturaSeleccionada: FacturaProveedorEntity | null;
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

export const initialFacturaProveedorState: FacturaProveedorState = {
  facturas: [],
  facturaSeleccionada: null,
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
