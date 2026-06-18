import { FacturaNoCompraEntity } from '../domain/models/factura-no-compra.entity';

/**
 * Estado del store de Factura No Compra
 */
export interface FacturaNoCompraState {
  facturas: FacturaNoCompraEntity[];
  facturaSeleccionada: FacturaNoCompraEntity | null;
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

export const initialFacturaNoCompraState: FacturaNoCompraState = {
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
