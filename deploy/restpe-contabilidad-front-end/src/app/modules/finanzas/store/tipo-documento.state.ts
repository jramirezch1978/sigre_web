export interface TipoDocumentoState {
  tiposDocumento: any[];
  tipoDocumentoSeleccionado: any | null;

  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingEliminar: boolean;
  loadingActualizar: boolean;

  errorObtener: string | null;
  errorGuardar: string | null;
  errorEliminar: string | null;
  errorActualizar: string | null;

  resultGuardar: any | null;
  resultEliminar: any | null;
  resultActualizar: any | null;
}

export const initialTipoDocumentoState: TipoDocumentoState = {
  tiposDocumento: [],
  tipoDocumentoSeleccionado: null,
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
  resultActualizar: null,
};
