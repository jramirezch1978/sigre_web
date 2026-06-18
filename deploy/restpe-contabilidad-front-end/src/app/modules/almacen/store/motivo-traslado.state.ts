import { BackendApiResponse } from "../application/dto/almacen-backend.types";
import { MotivoTrasladoAlmacenEntity } from "../domain/models/motivo-traslado-almacen.entity";

// motivo-traslado.state.ts
export interface MotivoTrasladoState {
  motivos: MotivoTrasladoAlmacenEntity[];
  motivoSeleccionado: MotivoTrasladoAlmacenEntity | null;

  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingEliminar: boolean;
  loadingActualizar: boolean;

  errorObtener: string | null;
  errorGuardar: string | null;
  errorEliminar: string | null;
  errorActualizar: string | null;

  resultGuardar: MotivoTrasladoAlmacenEntity | null;
  resultEliminar: BackendApiResponse<boolean> | null;
  resultActualizar: BackendApiResponse<MotivoTrasladoAlmacenEntity> | null;
}

export const initialMotivoTrasladoState: MotivoTrasladoState = {
  motivos: [],
  motivoSeleccionado: null,
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