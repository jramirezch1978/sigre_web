import { Observable } from 'rxjs';
import { AlmacenEntity } from '../models/almacen.entity';
import { TipoAlmacenEntity } from '../models/tipo-almacen.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export abstract class IAlmacenRepository {
  abstract obtenerTodos(): Observable<AlmacenEntity[]>;

  /** Catálogo de tipos de almacén (`/almacen-tipos`) para el selector del form. */
  abstract obtenerTiposAlmacen(): Observable<TipoAlmacenEntity[]>;

  abstract obtenerPorCodigo(almacen_codigo: string): Observable<AlmacenEntity>;
  
  abstract guardar(almacen: AlmacenEntity): Observable<ApiResponse<AlmacenEntity>>;
  
  abstract actualizar(almacen: AlmacenEntity): Observable<ApiResponse<AlmacenEntity>>;
  
  abstract eliminar(almacen_codigo: string): Observable<ApiResponse<boolean>>;
}
