import { Observable } from 'rxjs';
import { NumTrasladoEntity } from '../models/num-traslado.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato de repositorio para Numerador de Traslados de Activos Fijos.
 * Define las operaciones CRUD sin detalles de implementación.
 */
export abstract class INumTrasladoRepository {
  abstract obtenerTodos(): Observable<NumTrasladoEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<NumTrasladoEntity>;
  abstract guardar(numTraslado: NumTrasladoEntity): Observable<ApiResponse>;
  abstract actualizar(numTraslado: NumTrasladoEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
