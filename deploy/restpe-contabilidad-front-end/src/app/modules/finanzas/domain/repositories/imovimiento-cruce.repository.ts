import { Observable } from 'rxjs';
import { MovimientoCruceEntity } from '../models/movimiento-cruce.entity';

export abstract class IMovimientoCruceRepository {
  abstract obtenerMovimientos(): Observable<MovimientoCruceEntity[]>;
}
