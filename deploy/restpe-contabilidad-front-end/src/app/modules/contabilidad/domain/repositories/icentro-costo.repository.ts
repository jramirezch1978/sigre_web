import { Observable } from 'rxjs';
import { CentroCostoEntity } from '../models/centro-costo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export abstract class ICentroCostoRepository {
  abstract obtenerTodos(): Observable<CentroCostoEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<CentroCostoEntity | null>;
  abstract guardar(centro: CentroCostoEntity): Observable<ApiResponse<CentroCostoEntity>>;
  abstract actualizar(centro: CentroCostoEntity): Observable<ApiResponse<CentroCostoEntity>>;
  abstract eliminar(codigo: string): Observable<ApiResponse<boolean>>;
}
