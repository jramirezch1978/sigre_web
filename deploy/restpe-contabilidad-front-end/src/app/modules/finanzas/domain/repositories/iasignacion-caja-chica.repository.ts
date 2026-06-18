import { Observable } from 'rxjs';
import { AsignacionCajaChicaEntity } from '../models/asignacion-caja-chica.entity';

export abstract class IAsignacionCajaChicaRepository {
  abstract obtenerTodos(): Observable<AsignacionCajaChicaEntity[]>;
}
