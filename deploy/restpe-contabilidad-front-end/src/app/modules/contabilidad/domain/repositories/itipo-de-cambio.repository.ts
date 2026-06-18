import { Observable } from 'rxjs';
import { TipoDeCambioEntity } from '../models/tipo-de-cambio.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export abstract class ITipoDeCambioRepository {
  abstract obtenerTodos(): Observable<TipoDeCambioEntity[]>;
  abstract guardar(item: TipoDeCambioEntity): Observable<ApiResponse<TipoDeCambioEntity>>;
  abstract actualizar(item: TipoDeCambioEntity): Observable<ApiResponse<TipoDeCambioEntity>>;
  abstract eliminar(id: number): Observable<ApiResponse<boolean>>;
}
