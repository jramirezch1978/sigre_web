import { Observable } from 'rxjs';
import { GeneracionAsientosRevaluacionEntity } from '../models/generacion-asientos-revaluacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export abstract class IGeneracionAsientosRevaluacionRepository {
  abstract obtenerTodos(): Observable<GeneracionAsientosRevaluacionEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<GeneracionAsientosRevaluacionEntity>;
  abstract guardar(item: GeneracionAsientosRevaluacionEntity): Observable<ApiResponse>;
  abstract actualizar(item: GeneracionAsientosRevaluacionEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
