import { Observable } from 'rxjs';
import { GeneracionDevengoAseguradoresEntity } from '../models/generacion-devengo-aseguradores.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export abstract class IGeneracionDevengoAseguradoresRepository {
  abstract obtenerTodos(): Observable<GeneracionDevengoAseguradoresEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<GeneracionDevengoAseguradoresEntity>;
  abstract guardar(item: GeneracionDevengoAseguradoresEntity): Observable<ApiResponse>;
  abstract actualizar(item: GeneracionDevengoAseguradoresEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
