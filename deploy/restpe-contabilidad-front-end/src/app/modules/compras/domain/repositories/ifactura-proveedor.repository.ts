import { Observable } from 'rxjs';
import { FacturaProveedorEntity } from '../models/factura-proveedor.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato del repositorio de Facturas de Proveedor - Domain Layer
 * Clase abstracta usada como token de inyección de dependencias
 */
export abstract class IFacturaProveedorRepository {
  abstract obtenerFacturas(): Observable<FacturaProveedorEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<FacturaProveedorEntity>;
  abstract guardar(factura: FacturaProveedorEntity): Observable<ApiResponse<FacturaProveedorEntity>>;
  abstract actualizar(factura: FacturaProveedorEntity): Observable<ApiResponse<FacturaProveedorEntity>>;
  abstract eliminar(codigo: string): Observable<ApiResponse<boolean>>;
}
