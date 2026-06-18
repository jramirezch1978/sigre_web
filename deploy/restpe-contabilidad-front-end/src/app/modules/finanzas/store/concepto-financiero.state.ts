import { ConceptoFinancieroEntity } from '../domain/models/concepto-financiero.entity';

export interface ConceptoFinancieroState {
  conceptos: ConceptoFinancieroEntity[];

  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingActualizar: boolean;
  loadingEliminar: boolean;

  errorObtener: string | null;
  errorGuardar: string | null;
  errorActualizar: string | null;
  errorEliminar: string | null;

  resultGuardar: ConceptoFinancieroEntity | null;
  resultActualizar: ConceptoFinancieroEntity | null;
  resultEliminar: { success: boolean } | null;
}

export const initialConceptoFinancieroState: ConceptoFinancieroState = {
  conceptos: [],

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
