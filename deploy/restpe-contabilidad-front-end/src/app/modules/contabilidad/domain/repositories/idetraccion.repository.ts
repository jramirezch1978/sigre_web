import { Observable } from 'rxjs';
import { DetraccionEntity } from '../models/detraccion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export abstract class IDetraccionRepository {
  abstract obtenerTodos(): Observable<DetraccionEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<DetraccionEntity | null>;
  abstract guardar(detraccion: DetraccionEntity): Observable<ApiResponse<DetraccionEntity>>;
  abstract actualizar(detraccion: DetraccionEntity): Observable<ApiResponse<DetraccionEntity>>;
  abstract eliminar(codigo: string): Observable<ApiResponse<boolean>>;
}
