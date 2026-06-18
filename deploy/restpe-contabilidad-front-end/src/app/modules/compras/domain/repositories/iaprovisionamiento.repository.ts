import { Observable } from 'rxjs';
import { PlanAbastecimientoEntity } from '../models/plan-abastecimiento.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Repositorio abstracto: Plan de Abastecimiento
 * Define el contrato que toda implementación debe cumplir
 */
export abstract class IAprovisionamientoRepository {
  abstract obtenerPlanes(): Observable<PlanAbastecimientoEntity[]>;
  abstract obtenerPorNumero(numeroPlan: string): Observable<PlanAbastecimientoEntity>;
  abstract guardar(plan: PlanAbastecimientoEntity): Observable<ApiResponse<PlanAbastecimientoEntity>>;
  abstract actualizar(plan: PlanAbastecimientoEntity): Observable<ApiResponse<PlanAbastecimientoEntity>>;
  abstract eliminar(numeroPlan: string): Observable<ApiResponse<boolean>>;
}
