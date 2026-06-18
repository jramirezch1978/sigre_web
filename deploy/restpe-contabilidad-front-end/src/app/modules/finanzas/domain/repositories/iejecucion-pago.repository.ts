import { Observable } from 'rxjs';
import { EjecucionPagoEntity } from '../models/ejecucion-pago.entity';

export abstract class IEjecucionPagoRepository {
  abstract obtenerTodos(): Observable<EjecucionPagoEntity[]>;
  abstract guardar(entity: EjecucionPagoEntity): Observable<EjecucionPagoEntity>;
  abstract anular(ep_codigo: string): Observable<void>;
}
