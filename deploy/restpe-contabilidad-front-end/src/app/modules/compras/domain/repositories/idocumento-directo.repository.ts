import { Observable } from 'rxjs';
import { DocumentoDirectoEntity } from '../models/documento-directo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato del repositorio de Documentos por Pagar Directo (DPD).
 */
export abstract class IDocumentoDirectoRepository {
  abstract obtenerDocumentos(): Observable<DocumentoDirectoEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<DocumentoDirectoEntity>;
  abstract guardar(documento: DocumentoDirectoEntity): Observable<ApiResponse<DocumentoDirectoEntity>>;
  abstract actualizar(documento: DocumentoDirectoEntity): Observable<ApiResponse<DocumentoDirectoEntity>>;
  abstract anular(codigo: string): Observable<ApiResponse<boolean>>;
}
