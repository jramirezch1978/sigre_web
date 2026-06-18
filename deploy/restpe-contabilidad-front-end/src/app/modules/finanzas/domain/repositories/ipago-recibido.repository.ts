import { Observable } from 'rxjs';
import { PagoRecibidoEntity } from '../models/pago-recibido.entity';

export abstract class IPagoRecibidoRepository {
  abstract obtenerTodos(): Observable<PagoRecibidoEntity[]>;
}
