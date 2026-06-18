import { DocumentoClienteEntity } from '../domain/models/documento-cliente.entity';

export interface DocumentoClienteState {
  documentos: DocumentoClienteEntity[];
  isLoading: boolean;
  error: string | null;
}

export const initialDocumentoClienteState: DocumentoClienteState = {
  documentos: [],
  isLoading: false,
  error: null,
};
