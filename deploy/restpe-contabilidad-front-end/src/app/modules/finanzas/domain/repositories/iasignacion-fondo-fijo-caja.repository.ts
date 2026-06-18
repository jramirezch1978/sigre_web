import { Observable } from 'rxjs';
import { AsignacionFondoFijoCajaEntity } from '../models/asignacion-fondo-fijo-caja.entity';

export abstract class IAsignacionFondoFijoCajaRepository {
  abstract obtenerTodos(): Observable<AsignacionFondoFijoCajaEntity[]>;
}
