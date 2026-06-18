import { Observable } from 'rxjs';
import { RegistroIngresoDeDiaEntity } from '../models/registro-ingreso-de-dia.entity';

export abstract class IRegistroIngresoDeDiaRepository {
  abstract obtenerIngresos(): Observable<RegistroIngresoDeDiaEntity[]>;
}
