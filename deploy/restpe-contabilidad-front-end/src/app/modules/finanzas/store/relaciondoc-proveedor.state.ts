import { RelacionDocProveedorMap } from '../domain/models/relaciondoc-proveedor.entity';

export interface RelacionDocProveedorState {
  facturasPorProveedor: RelacionDocProveedorMap;
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialRelacionDocProveedorState: RelacionDocProveedorState = {
  facturasPorProveedor: {},
  loadingObtener: false,
  errorObtener: null,
};
