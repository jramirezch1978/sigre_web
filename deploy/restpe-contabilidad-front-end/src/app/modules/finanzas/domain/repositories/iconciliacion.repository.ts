import { Observable } from 'rxjs';
import { ConciliacionEntity } from '../models/conciliacion.entity';

export abstract class IConciliacionRepository {
  abstract obtenerConciliaciones(): Observable<ConciliacionEntity[]>;
}
