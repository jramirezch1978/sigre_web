import { Observable } from 'rxjs';
import { MaestroContableEntity } from '../models/maestro-contable.entity';

/**
 * IMaestroContableRepository — Contrato del Dominio.
 * Define la operación de lectura del Maestro Contable.
 * La implementación concreta vive en la capa de infraestructura.
 */
export abstract class IMaestroContableRepository {
  abstract obtenerTodos(): Observable<MaestroContableEntity>;
}
