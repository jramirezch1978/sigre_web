import { Observable } from 'rxjs';
import { IncidenciaEntity } from '../models/incidencia.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato (puerto) del repositorio de Incidencias.
 * Principio de Inversión de Dependencias (DIP): la capa de aplicación
 * depende de esta abstracción, no de la implementación concreta.
 */
export abstract class IIncidenciaRepository {
  abstract obtenerTodos(): Observable<IncidenciaEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<IncidenciaEntity>;
  abstract guardar(incidencia: IncidenciaEntity): Observable<ApiResponse>;
  abstract actualizar(incidencia: IncidenciaEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
