import { SunatTipoDocumentoEntity } from '../domain/models/tipo-documento.entity';

export interface SunatTipoDocumentoState {
  sunatDocumentos: SunatTipoDocumentoEntity[];
  sunatDocumentosActivos: SunatTipoDocumentoEntity[];

  loadingObtener: boolean;

  errorObtener: string | null;
}

export const initialSunatTipoDocumentoState: SunatTipoDocumentoState = {
  sunatDocumentos: [],
  sunatDocumentosActivos: [],
  loadingObtener: false,
  errorObtener: null,
};
