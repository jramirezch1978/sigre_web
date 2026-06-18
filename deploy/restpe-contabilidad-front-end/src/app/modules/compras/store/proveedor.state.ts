import { ProveedorEntity } from '../domain/models/proveedor.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface ProveedorState {
  proveedores: ProveedorEntity[];
  proveedorSeleccionado: ProveedorEntity | null;

  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingEliminar: boolean;
  loadingActualizar: boolean;

  errorObtener: string | null;
  errorGuardar: string | null;
  errorEliminar: string | null;
  errorActualizar: string | null;

  resultGuardar: ApiResponse<ProveedorEntity> | null;
  resultEliminar: ApiResponse<boolean> | null;
  resultActualizar: ApiResponse<ProveedorEntity> | null;
}

export const initialProveedorState: ProveedorState = {
  proveedores: [],
  proveedorSeleccionado: null,

  loadingObtener: false,
  loadingGuardar: false,
  loadingEliminar: false,
  loadingActualizar: false,

  errorObtener: null,
  errorGuardar: null,
  errorEliminar: null,
  errorActualizar: null,

  resultGuardar: null,
  resultEliminar: null,
  resultActualizar: null
};
