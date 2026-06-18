import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IAprovisionamientoRepository } from '../../../domain/repositories/iaprovisionamiento.repository';
import { PlanAbastecimientoEntity } from '../../../domain/models/plan-abastecimiento.entity';
import { AprovisionamientoStore } from '../../../stores/aprovisionamiento.store';

/**
 * Caso de uso: Actualizar Plan de Abastecimiento
 */
@Injectable()
export class ActualizarPlanAbastecimientoUseCase {
  private readonly repository = inject(IAprovisionamientoRepository);
  private readonly store = inject(AprovisionamientoStore);

  execute(plan: PlanAbastecimientoEntity) {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);

    return this.repository.actualizar(plan).pipe(
      tap((response) => {
        if (response.success) {
          console.log('  Plan de abastecimiento actualizado:', response.data?.plan_abastecimiento_numero);
        }
      }),
      catchError((error) => {
        const errorMsg = 'Error al actualizar el plan de abastecimiento';
        this.store.setErrorActualizar(errorMsg);
        console.error(errorMsg, error);
        return of({ success: false, message: errorMsg, data: null as any });
      }),
      finalize(() => {
        this.store.setLoadingActualizar(false);
      })
    );
  }
}
