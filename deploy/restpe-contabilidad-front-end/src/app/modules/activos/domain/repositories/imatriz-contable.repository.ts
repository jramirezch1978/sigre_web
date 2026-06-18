import { Observable } from 'rxjs';
import { MatrizContableEntity } from '../models/matriz-contable.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Puerto (interfaz) del repositorio de Matriz Contable.
 * DIP: la capa de aplicación depende de esta abstracción, no del impl concreto.
 */
export abstract class IMatrizContableRepository {
  abstract obtenerTodos(): Observable<MatrizContableEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<MatrizContableEntity>;
  abstract guardar(matriz: MatrizContableEntity): Observable<ApiResponse>;
  abstract actualizar(matriz: MatrizContableEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
