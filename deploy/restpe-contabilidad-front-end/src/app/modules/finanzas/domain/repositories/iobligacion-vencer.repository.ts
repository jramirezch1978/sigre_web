import { Observable } from 'rxjs';
import { ObligacionVencerEntity } from '../models/obligacion-vencer.entity';

export abstract class IObligacionVencerRepository {
  abstract obtenerObligaciones(): Observable<ObligacionVencerEntity[]>;
}
