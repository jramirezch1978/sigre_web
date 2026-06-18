import { Observable } from 'rxjs';
import { CondicionPagoEntity } from '../models/condicion-pago.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export abstract class ICondicionPagoRepository {
  abstract obtenerTodos(): Observable<CondicionPagoEntity[]>;
  
  abstract obtenerPorCodigo(codigo: string): Observable<CondicionPagoEntity>;
  
  abstract guardar(condicion: CondicionPagoEntity): Observable<ApiResponse<CondicionPagoEntity>>;
  
  abstract actualizar(condicion: CondicionPagoEntity): Observable<ApiResponse<CondicionPagoEntity>>;
  
  abstract eliminar(codigo: string): Observable<ApiResponse<boolean>>;
}
