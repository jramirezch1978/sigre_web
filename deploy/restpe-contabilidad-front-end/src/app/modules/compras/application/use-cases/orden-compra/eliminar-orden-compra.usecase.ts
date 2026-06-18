import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IOrdenCompraRepository } from '../../../domain/repositories/iorden-compra.repository';
import { OrdenCompraStore } from '../../../stores/orden-compra.store';

/**
 * Caso de uso: Eliminar Orden de Compra
 * Elimina una orden de compra por su número de orden y actualiza el store
 */
@Injectable()
export class EliminarOrdenCompraUseCase {
  private readonly repository = inject(IOrdenCompraRepository);
  private readonly store = inject(OrdenCompraStore);

  execute(numeroOrden: string) {
    this.store.setLoadingEliminar(true);
    this.store.setErrorEliminar(null);

    return this.repository.eliminarOrdenCompra(numeroOrden).pipe(
      tap((eliminada) => {
        if (eliminada) {
          this.store.eliminarOrdenCompraDelStore(numeroOrden);
          console.log('  Orden de compra eliminada:', numeroOrden);
        }
      }),
      catchError((error) => {
        const errorMsg = 'Error al eliminar orden de compra';
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
