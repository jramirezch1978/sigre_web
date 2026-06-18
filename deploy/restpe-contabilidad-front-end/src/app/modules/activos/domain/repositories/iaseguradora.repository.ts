import { Observable } from 'rxjs';
import { AseguradoraEntity } from '../models/aseguradora.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato del repositorio de Aseguradoras.
 * Define todas las operaciones de acceso a datos disponibles.
 */
export abstract class IAseguradoraRepository {
  abstract obtenerTodos(): Observable<AseguradoraEntity[]>;
  abstract obtenerPorCodigo(codigo: string): Observable<AseguradoraEntity>;
  abstract guardar(aseguradora: AseguradoraEntity): Observable<ApiResponse<AseguradoraEntity>>;
  abstract actualizar(aseguradora: AseguradoraEntity): Observable<ApiResponse<AseguradoraEntity>>;
  abstract eliminar(codigo: string): Observable<ApiResponse<boolean>>;
}
