import { GestionGrupoEntity } from '../domain/models/gestion-grupo.entity';

export interface GestionGrupoState {
  grupos: GestionGrupoEntity[];
  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  resultGuardar: { success: boolean; data?: GestionGrupoEntity } | null;
  resultActualizar: { success: boolean; data?: GestionGrupoEntity } | null;
}

export const GESTION_GRUPO_INITIAL_STATE: GestionGrupoState = {
  grupos: [],
  loadingObtener: false,
  loadingGuardar: false,
  loadingActualizar: false,
  errorObtener: null,
  errorGuardar: null,
  errorActualizar: null,
  resultGuardar: null,
  resultActualizar: null,
};
