import { GestionCatalogoEntity } from '../domain/models/gestion-catalogo.entity';

export interface GestionCatalogoState {
  documentos: GestionCatalogoEntity[];
  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  loadingEliminar: boolean;
  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  errorEliminar: string | null;
  resultGuardar: { success: boolean; data?: GestionCatalogoEntity } | null;
  resultActualizar: { success: boolean; data?: GestionCatalogoEntity } | null;
  resultEliminar: { success: boolean } | null;
}

export const GESTION_CATALOGO_INITIAL_STATE: GestionCatalogoState = {
  documentos: [],
  loadingObtener: false,
  loadingGuardar: false,
  loadingActualizar: false,
  loadingEliminar: false,
  errorObtener: null,
  errorGuardar: null,
  errorActualizar: null,
  errorEliminar: null,
  resultGuardar: null,
  resultActualizar: null,
  resultEliminar: null,
};
