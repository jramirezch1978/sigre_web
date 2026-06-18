import { Observable } from 'rxjs';
import { ActivoFijoEntity } from '../models/activo-fijo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato del repositorio de Activos Fijos.
 * Define todas las operaciones de acceso a datos disponibles.
 */
export abstract class IActivoFijoRepository {
  abstract obtenerTodos(): Observable<ActivoFijoEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<ActivoFijoEntity>;
  abstract guardar(activo: ActivoFijoEntity): Observable<ApiResponse<ActivoFijoEntity>>;
  abstract actualizar(activo: ActivoFijoEntity): Observable<ApiResponse<ActivoFijoEntity>>;
  abstract eliminar(codigo: string): Observable<ApiResponse<boolean>>;
}
