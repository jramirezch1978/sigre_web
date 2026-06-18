import { Observable } from 'rxjs';
import { DocumentoClienteEntity } from '../models/documento-cliente.entity';

export abstract class IDocumentoClienteRepository {
  abstract obtenerDocumentos(): Observable<DocumentoClienteEntity[]>;
}
