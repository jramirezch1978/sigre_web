import { Observable } from 'rxjs';
import { ProveedorEntity } from '../models/proveedor.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export interface ProveedorFiltro {
  razonSocial?: string;
  nroDocumento?: string;
  /** Filtra por estado: true = activos, false = inactivos, undefined = todos. */
  activo?: boolean;
}

export abstract class IProveedorRepository {
  abstract obtenerTodos(filtros?: ProveedorFiltro): Observable<ProveedorEntity[]>;
  
  abstract obtenerPorCodigo(codigo: string): Observable<ProveedorEntity>;
  
  abstract guardar(proveedor: ProveedorEntity): Observable<ApiResponse<ProveedorEntity>>;
  
  abstract actualizar(proveedor: ProveedorEntity): Observable<ApiResponse<ProveedorEntity>>;
  
  abstract eliminar(codigo: string): Observable<ApiResponse<boolean>>;
}
