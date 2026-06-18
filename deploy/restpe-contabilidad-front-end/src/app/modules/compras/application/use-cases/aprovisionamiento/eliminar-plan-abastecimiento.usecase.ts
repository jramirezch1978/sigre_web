import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IAprovisionamientoRepository } from '../../../domain/repositories/iaprovisionamiento.repository';
import { AprovisionamientoStore } from '../../../stores/aprovisionamiento.store';

/**
 * Caso de uso: Eliminar Plan de Abastecimiento
 */
@Injectable()
export class EliminarPlanAbastecimientoUseCase {
  private readonly repository = inject(IAprovisionamientoRepository);
  private readonly store = inject(AprovisionamientoStore);

  execute(numeroPlan: string) {
    this.store.setLoadingEliminar(true);
    this.store.setErrorEliminar(null);

    return this.repository.eliminar(numeroPlan).pipe(
      tap((response) => {
        if (response.success) {
          console.log('  Plan de abastecimiento eliminado:', numeroPlan);
        }
      }),
      catchError((error) => {
        const errorMsg = 'Error al eliminar el plan de abastecimiento';
        this.store.setErrorEliminar(errorMsg);
        console.error(errorMsg, error);
        return of({ success: false, message: errorMsg, data: false });
      }),
      finalize(() => {
        this.store.setLoadingEliminar(false);
      })
    );
  }
}
