import { Observable } from 'rxjs';
import { ClasifActivoEntity } from '../models/clasif-activo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato (puerto) del repositorio de Clasificación de Activos.
 * Principio de Inversión de Dependencias (DIP): la capa de aplicación
 * depende de esta abstracción, no de la implementación concreta.
 */
export abstract class IClasifActivoRepository {
  abstract obtenerTodos(): Observable<ClasifActivoEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<ClasifActivoEntity>;
  abstract guardar(clasif: ClasifActivoEntity): Observable<ApiResponse>;
  abstract actualizar(clasif: ClasifActivoEntity): Observable<ApiResponse>;
  abstract eliminar(codigo: string): Observable<ApiResponse>;
}
