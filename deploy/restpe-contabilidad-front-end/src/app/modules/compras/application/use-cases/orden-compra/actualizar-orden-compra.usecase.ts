import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IOrdenCompraRepository } from '../../../domain/repositories/iorden-compra.repository';
import { OrdenCompraStore } from '../../../stores/orden-compra.store';
import { OrdenCompraEntity } from '../../../domain/models/orden-compra.entity';

/**
 * Caso de uso: Actualizar Orden de Compra
 * Actualiza una orden de compra existente y actualiza el store
 */
@Injectable()
export class ActualizarOrdenCompraUseCase {
  private readonly repository = inject(IOrdenCompraRepository);
  private readonly store = inject(OrdenCompraStore);

  execute(ordenCompra: OrdenCompraEntity) {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);

    return this.repository.actualizarOrdenCompra(ordenCompra).pipe(
      tap((ordenActualizada) => {
        this.store.actualizarOrdenCompraEnStore(ordenActualizada);
        console.log('  Orden de compra actualizada:', ordenActualizada.orden_compra_numero);
      }),
      catchError((error) => {
        const errorMsg = 'Error al actualizar orden de compra';
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
