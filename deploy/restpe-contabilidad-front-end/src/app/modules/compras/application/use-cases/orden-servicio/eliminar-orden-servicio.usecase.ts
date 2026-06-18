import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IOrdenServicioRepository } from '../../../domain/repositories/iorden-servicio.repository';
import { OrdenServicioStore } from '../../../stores/orden-servicio.store';

/**
 * Caso de uso: Eliminar Orden de Servicio
 * Elimina una orden de servicio por su número de orden y actualiza el store
 */
@Injectable()
export class EliminarOrdenServicioUseCase {
  private readonly repository = inject(IOrdenServicioRepository);
  private readonly store = inject(OrdenServicioStore);

  execute(numeroOrden: string) {
    this.store.setLoadingEliminar(true);
    this.store.setErrorEliminar(null);

    return this.repository.eliminarOrdenServicio(numeroOrden).pipe(
      tap((eliminada) => {
        if (eliminada) {
          this.store.eliminarOrdenServicioDelStore(numeroOrden);
          console.log('  Orden de servicio eliminada:', numeroOrden);
        }
      }),
      catchError((error) => {
        const errorMsg = 'Error al eliminar orden de servicio';
        this.store.setErrorEliminar(errorMsg);
        console.error(errorMsg, error);
        return of(false);
      }),
      finalize(() => {
        this.store.setLoadingEliminar(false);
      })
    );
  }
}
