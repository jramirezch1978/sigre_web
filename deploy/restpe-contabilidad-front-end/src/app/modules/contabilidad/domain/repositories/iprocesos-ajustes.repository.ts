import { Observable } from 'rxjs';
import { ProcesosAjustesEntity } from '../models/procesos-ajustes.entity';

/**
 * IProcesosAjustesRepository — Puerto de dominio (lectura).
 * Define el contrato que debe cumplir la implementación de infraestructura.
 */
export abstract class IProcesosAjustesRepository {
  abstract obtenerTodos(): Observable<ProcesosAjustesEntity>;
}
