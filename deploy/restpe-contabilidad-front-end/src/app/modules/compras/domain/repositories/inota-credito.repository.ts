import { Observable } from 'rxjs';
import { NotaCreditoEntity } from '../models/nota-credito.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato del repositorio de Notas de Crédito/Débito - Domain Layer
 * Clase abstracta usada como token de inyección de dependencias
 */
export abstract class INotaCreditoRepository {
  abstract obtenerNotas(): Observable<NotaCreditoEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<NotaCreditoEntity>;
  abstract guardar(nota: NotaCreditoEntity): Observable<ApiResponse<NotaCreditoEntity>>;
  abstract actualizar(nota: NotaCreditoEntity): Observable<ApiResponse<NotaCreditoEntity>>;
  abstract eliminar(codigo: string): Observable<ApiResponse<boolean>>;
}
