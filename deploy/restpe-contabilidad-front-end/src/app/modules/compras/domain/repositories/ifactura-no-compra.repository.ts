import { Observable } from 'rxjs';
import { FacturaNoCompraEntity } from '../models/factura-no-compra.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Repositorio abstracto: Factura No Compra
 * Define el contrato que toda implementación debe cumplir
 */
export abstract class IFacturaNoCompraRepository {
  abstract obtenerFacturas(): Observable<FacturaNoCompraEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<FacturaNoCompraEntity>;
  abstract guardar(factura: FacturaNoCompraEntity): Observable<ApiResponse<FacturaNoCompraEntity>>;
  abstract actualizar(factura: FacturaNoCompraEntity): Observable<ApiResponse<FacturaNoCompraEntity>>;
  abstract eliminar(codigo: string): Observable<ApiResponse<boolean>>;
}
