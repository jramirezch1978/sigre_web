import { Observable } from 'rxjs';
import { GeneracionAsientosIndexacionEntity } from '../models/generacion-asientos-indexacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export abstract class IGeneracionAsientosIndexacionRepository {
  abstract obtenerTodos(): Observable<GeneracionAsientosIndexacionEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<GeneracionAsientosIndexacionEntity>;
  abstract guardar(item: GeneracionAsientosIndexacionEntity): Observable<ApiResponse>;
  abstract actualizar(item: GeneracionAsientosIndexacionEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
