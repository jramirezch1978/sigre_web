import { Observable } from 'rxjs';
import { FacturacionRegaliasEntity } from '../models/facturacion-regalias.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export abstract class IFacturacionRegaliasRepository {
  abstract obtenerTodos(): Observable<FacturacionRegaliasEntity[]>;

  abstract obtenerPorCodigo(codigo: string): Observable<FacturacionRegaliasEntity>;

  abstract guardar(factura: FacturacionRegaliasEntity): Observable<ApiResponse<FacturacionRegaliasEntity>>;

  abstract anular(codigo: string, motivo: string): Observable<ApiResponse<FacturacionRegaliasEntity>>;
}
