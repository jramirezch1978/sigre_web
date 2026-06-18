import { Observable } from 'rxjs';
import { AprobarGiroEntity } from '../models/aprobar-giro.entity';

export abstract class IAprobarGiroRepository {
  abstract obtenerTodos(): Observable<AprobarGiroEntity[]>;
  abstract actualizar(entity: AprobarGiroEntity): Observable<AprobarGiroEntity>;
}
