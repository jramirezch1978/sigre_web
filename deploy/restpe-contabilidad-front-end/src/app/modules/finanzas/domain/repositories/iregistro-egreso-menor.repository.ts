import { Observable } from 'rxjs';
import { RegistroEgresoMenorEntity } from '../models/registro-egreso-menor.entity';

export abstract class IRegistroEgresoMenorRepository {
  abstract obtenerTodos(): Observable<RegistroEgresoMenorEntity[]>;
}
