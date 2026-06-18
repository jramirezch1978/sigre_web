import { ConsultaDocumentosEntity } from '../domain/models/consulta-documentos.entity';

export interface ConsultaDocumentosState {
  registros: ConsultaDocumentosEntity[];
  loadingObtener: boolean;
  errorObtener: string | null;
}

export const initialConsultaDocumentosState: ConsultaDocumentosState = {
  registros: [],
  loadingObtener: false,
  errorObtener: null,
};
