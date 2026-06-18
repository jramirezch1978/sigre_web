import { Observable } from 'rxjs';
import { CuentaVsSubcategoriaEntity } from '../models/cuenta-vs-subcategoria.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export abstract class ICuentaVsSubcategoriaRepository {
  abstract obtenerTodos(): Observable<CuentaVsSubcategoriaEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<CuentaVsSubcategoriaEntity | null>;
  abstract actualizar(item: CuentaVsSubcategoriaEntity): Observable<ApiResponse<CuentaVsSubcategoriaEntity>>;
}
