import { Observable } from 'rxjs';
import { ConsultaDocumentosEntity } from '../models/consulta-documentos.entity';

export abstract class IConsultaDocumentosRepository {
  abstract obtenerTodos(): Observable<ConsultaDocumentosEntity[]>;
}
