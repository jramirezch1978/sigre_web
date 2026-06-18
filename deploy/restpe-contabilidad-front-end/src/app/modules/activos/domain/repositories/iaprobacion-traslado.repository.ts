import { Observable } from 'rxjs';
import { AprobacionTrasladoEntity } from '../models/aprobacion-traslado.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export abstract class IAprobacionTrasladoRepository {
  abstract obtenerTodos(): Observable<AprobacionTrasladoEntity[]>;
  abstract obtenerPorCodigo(id: string): Observable<AprobacionTrasladoEntity>;
  abstract guardar(item: AprobacionTrasladoEntity): Observable<ApiResponse>;
  abstract actualizar(item: AprobacionTrasladoEntity): Observable<ApiResponse>;
  abstract eliminar(id: string): Observable<ApiResponse>;
}
