import { ProveedorActivoEntity } from '../domain/models/proveedor-activo.entity';

export interface ProveedorActivoState {
  proveedores: ProveedorActivoEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialProveedorActivoState: ProveedorActivoState = {
  proveedores: [],
  loadingObtener: false,
  errorObtener: null,
};
