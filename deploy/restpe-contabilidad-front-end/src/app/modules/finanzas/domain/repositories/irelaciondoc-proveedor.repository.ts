import { Observable } from 'rxjs';
import { RelacionDocProveedorMap } from '../models/relaciondoc-proveedor.entity';

export abstract class IRelacionDocProveedorRepository {
  abstract obtenerTodos(): Observable<RelacionDocProveedorMap>;
}
