import { Observable } from 'rxjs';
import { NumActivoEntity } from '../models/num-activo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato de repositorio para Numerador de Activos Fijos.
 * Define las operaciones CRUD sin detalles de implementación.
 */
export abstract class INumActivoRepository {
  abstract obtenerTodos(): Observable<NumActivoEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<NumActivoEntity>;
  abstract guardar(numActivo: NumActivoEntity): Observable<ApiResponse>;
  abstract actualizar(numActivo: NumActivoEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
