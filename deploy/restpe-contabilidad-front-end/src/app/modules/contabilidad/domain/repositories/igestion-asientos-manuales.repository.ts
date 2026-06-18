import { Observable } from 'rxjs';
import { AsientoManualItem } from '../models/gestion-asientos-manual.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * IGestionAsientosManualesRepository — Puerto de dominio.
 * Define el contrato que debe cumplir la implementación de infraestructura.
 */
export abstract class IGestionAsientosManualesRepository {
  abstract obtenerTodos(): Observable<AsientoManualItem[]>;
  abstract guardar(asiento: AsientoManualItem): Observable<ApiResponse<AsientoManualItem>>;
  abstract actualizar(asiento: AsientoManualItem): Observable<ApiResponse<AsientoManualItem>>;
  abstract anular(nroAsiento: string): Observable<ApiResponse<boolean>>;
}
