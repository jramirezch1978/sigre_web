import { Observable } from 'rxjs';
import { RelacionDocClienteMap } from '../models/relaciondoc-cliente.entity';

export abstract class IRelacionDocClienteRepository {
  abstract obtenerTodos(): Observable<RelacionDocClienteMap>;
}
