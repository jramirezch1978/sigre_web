import { Observable } from 'rxjs';
import { RegistroFacturaEntity } from '../models/registro-factura.entity';

export abstract class IRegistroFacturaRepository {
  abstract obtenerTodos(): Observable<RegistroFacturaEntity[]>;
  abstract guardar(factura: RegistroFacturaEntity): Observable<RegistroFacturaEntity>;
  abstract actualizar(factura: RegistroFacturaEntity): Observable<RegistroFacturaEntity>;
}
