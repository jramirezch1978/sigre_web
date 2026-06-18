import { Observable } from 'rxjs';
import { CruceExtractoEntity } from '../models/cruce-extracto.entity';

export abstract class ICruceExtractoRepository {
  abstract obtenerCruces(): Observable<CruceExtractoEntity[]>;
}
