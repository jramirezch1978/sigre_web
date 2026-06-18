import { Observable } from 'rxjs';
import { CrucePasarelaEntity } from '../models/cruce-pasarela.entity';

export abstract class ICrucePasarelaRepository {
  abstract obtenerCruces(): Observable<CrucePasarelaEntity[]>;
}
