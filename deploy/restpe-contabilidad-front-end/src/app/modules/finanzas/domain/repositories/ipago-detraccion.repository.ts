import { Observable } from 'rxjs';
import { PagoDetraccionEntity } from '../models/pago-detraccion.entity';

export abstract class IPagoDetraccionRepository {
  abstract obtenerTodos(): Observable<PagoDetraccionEntity[]>;
}
