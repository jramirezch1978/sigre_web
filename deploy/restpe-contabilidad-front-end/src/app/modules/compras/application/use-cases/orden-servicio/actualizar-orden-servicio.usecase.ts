import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IOrdenServicioRepository } from '../../../domain/repositories/iorden-servicio.repository';
import { OrdenServicioStore } from '../../../stores/orden-servicio.store';
import { OrdenServicioEntity } from '../../../domain/models/orden-servicio.entity';

/**
 * Caso de uso: Actualizar Orden de Servicio
 * Actualiza una orden de servicio existente y actualiza el store
 */
@Injectable()
export class ActualizarOrdenServicioUseCase {
  private readonly repository = inject(IOrdenServicioRepository);
  private readonly store = inject(OrdenServicioStore);

  execute(ordenServicio: OrdenServicioEntity) {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);

    return this.repository.actualizarOrdenServicio(ordenServicio).pipe(
      tap((ordenActualizada) => {
        this.store.actualizarOrdenServicioEnStore(ordenActualizada);
        console.log('  Orden de servicio actualizada:', ordenActualizada.orden_servicio_numero);
      }),
      catchError((error) => {
        const errorMsg = 'Error al actualizar orden de servicio';
        this.store.setErrorActualizar(errorMsg);
        console.error(errorMsg, error);
        return of(null);
      }),
      finalize(() => {
        this.store.setLoadingActualizar(false);
      })
    );
  }
}
