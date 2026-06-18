import { Observable } from 'rxjs';
import { GeneracionAsientosSiniestroEntity } from '../models/generacion-asientos-siniestro.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export abstract class IGeneracionAsientosSiniestroRepository {
  abstract obtenerTodos(): Observable<GeneracionAsientosSiniestroEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<GeneracionAsientosSiniestroEntity>;
  abstract guardar(item: GeneracionAsientosSiniestroEntity): Observable<ApiResponse>;
  abstract actualizar(item: GeneracionAsientosSiniestroEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
