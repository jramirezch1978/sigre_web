import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IAprovisionamientoRepository } from '../../domain/repositories/iaprovisionamiento.repository';
import { PlanAbastecimientoEntity } from '../../domain/models/plan-abastecimiento.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Implementación del repositorio de Aprovisionamiento
 * Consume el JSON desde assets y simula operaciones CRUD con delay
 */
@Injectable({ providedIn: 'root' })
export class AprovisionamientoRepositoryImpl implements IAprovisionamientoRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/compras/operaciones/aprovisionamiento.json';

  obtenerPlanes(): Observable<PlanAbastecimientoEntity[]> {
    return this.http.get<PlanAbastecimientoEntity[]>(this.JSON_PATH).pipe(
      delay(500)
    );
  }

  obtenerPorNumero(numeroPlan: string): Observable<PlanAbastecimientoEntity> {
    return this.http.get<PlanAbastecimientoEntity[]>(this.JSON_PATH).pipe(
      delay(300),
      map(planes => {
        const plan = planes.find(p => p.plan_abastecimiento_numero === numeroPlan);
        if (!plan) {
          throw new Error(`Plan de abastecimiento con número ${numeroPlan} no encontrado`);
        }
        return plan;
      })
    );
  }

  guardar(plan: PlanAbastecimientoEntity): Observable<ApiResponse<PlanAbastecimientoEntity>> {
    const year = new Date().getFullYear();
    const codigo = `PA-${year}-${String(Math.floor(Math.random() * 9000) + 1000).padStart(3, '0')}`;
    return of({
      success: true,
      message: 'Plan de abastecimiento guardado exitosamente',
      data: { ...plan, plan_abastecimiento_numero: plan.plan_abastecimiento_numero || codigo }
    }).pipe(delay(800));
  }

  actualizar(plan: PlanAbastecimientoEntity): Observable<ApiResponse<PlanAbastecimientoEntity>> {
    return of({
      success: true,
      message: 'Plan de abastecimiento actualizado exitosamente',
      data: { ...plan }
    }).pipe(delay(800));
  }

  eliminar(numeroPlan: string): Observable<ApiResponse<boolean>> {
    return of({
      success: true,
      message: 'Plan de abastecimiento eliminado exitosamente',
      data: true
    }).pipe(delay(600));
  }
}
