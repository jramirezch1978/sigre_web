import { Observable } from 'rxjs';
import { AsignacionRatiosEntity } from '../models/asignacion-ratios.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export abstract class IAsignacionRatiosRepository {
  abstract obtenerTodos(): Observable<AsignacionRatiosEntity[]>;
  abstract obtenerPorCodigo(id: string): Observable<AsignacionRatiosEntity>;
  abstract guardar(item: AsignacionRatiosEntity): Observable<ApiResponse>;
  abstract actualizar(item: AsignacionRatiosEntity): Observable<ApiResponse>;
  abstract eliminar(id: string): Observable<ApiResponse>;
}
