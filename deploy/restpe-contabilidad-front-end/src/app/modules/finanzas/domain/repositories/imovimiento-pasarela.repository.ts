import { Observable } from 'rxjs';
import { MovimientoPasarelaEntity } from '../models/movimiento-pasarela.entity';

export abstract class IMovimientoPasarelaRepository {
  abstract obtenerMovimientos(): Observable<MovimientoPasarelaEntity[]>;
}
