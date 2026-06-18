import { Observable } from 'rxjs';
import { AnulacionPagosEntity } from '../models/anulacion-pagos.entity';

export abstract class IAnulacionPagosRepository {
  abstract obtenerTodos(): Observable<AnulacionPagosEntity[]>;
}
