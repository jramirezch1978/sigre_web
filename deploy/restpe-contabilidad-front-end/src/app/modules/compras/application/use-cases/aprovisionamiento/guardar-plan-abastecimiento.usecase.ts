import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IAprovisionamientoRepository } from '../../../domain/repositories/iaprovisionamiento.repository';
import { PlanAbastecimientoEntity } from '../../../domain/models/plan-abastecimiento.entity';
import { AprovisionamientoStore } from '../../../stores/aprovisionamiento.store';

/**
 * Caso de uso: Guardar Plan de Abastecimiento
 */
@Injectable()
export class GuardarPlanAbastecimientoUseCase {
  private readonly repository = inject(IAprovisionamientoRepository);
  private readonly store = inject(AprovisionamientoStore);

  execute(plan: PlanAbastecimientoEntity) {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);

    return this.repository.guardar(plan).pipe(
      tap((response) => {
        if (response.success) {
          console.log('  Plan de abastecimiento guardado:', response.data?.plan_abastecimiento_numero);
        }
      }),
      catchError((error) => {
        const errorMsg = 'Error al guardar el plan de abastecimiento';
        this.store.setErrorGuardar(errorMsg);
        console.error(errorMsg, error);
        return of({ success: false, message: errorMsg, data: null as any });
      }),
      finalize(() => {
        this.store.setLoadingGuardar(false);
      })
    );
  }
}
