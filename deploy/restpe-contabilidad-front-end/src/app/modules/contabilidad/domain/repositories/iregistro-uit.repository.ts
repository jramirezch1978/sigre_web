import { Observable } from 'rxjs';
import { RegistroUitEntity } from '../models/registro-uit.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * IRegistroUitRepository — Contrato del Dominio.
 * Define las operaciones permitidas sobre los Registros UIT.
 * Las implementaciones concretas viven en la capa de infraestructura.
 */
export abstract class IRegistroUitRepository {
  abstract obtenerTodos(): Observable<RegistroUitEntity[]>;
  abstract guardar(item: RegistroUitEntity): Observable<ApiResponse<RegistroUitEntity>>;
  abstract actualizar(item: RegistroUitEntity): Observable<ApiResponse<RegistroUitEntity>>;
}
