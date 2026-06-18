import { Observable } from 'rxjs';
import { LetraCambioEntity } from '../models/letra-cambio.entity';

export abstract class ILetraCambioRepository {
  abstract obtenerTodos(): Observable<LetraCambioEntity[]>;
  abstract guardar(letra: LetraCambioEntity): Observable<LetraCambioEntity>;
  abstract actualizar(letra: LetraCambioEntity): Observable<LetraCambioEntity>;
}
