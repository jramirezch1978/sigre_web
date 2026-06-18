import { PagosMasivosEntity } from '../domain/models/pagos-masivos.entity';
import { PagosMasivosDocumentoEntity } from '../domain/models/pagos-masivos-documento.entity';

export interface PagosMasivosState {
  registros: PagosMasivosEntity[];
  documentos: PagosMasivosDocumentoEntity[];
  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingDocumentos: boolean;
  errorObtener: string | null;
  errorGuardar: string | null;
  errorDocumentos: string | null;
  guardadoOk: boolean;
}

export const initialPagosMasivosState: PagosMasivosState = {
  registros: [],
  documentos: [],
  loadingObtener: false,
  loadingGuardar: false,
  loadingDocumentos: false,
  errorObtener: null,
  errorGuardar: null,
  errorDocumentos: null,
  guardadoOk: false,
};
