import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IOrdenCompraRepository } from '../../../domain/repositories/iorden-compra.repository';
import { OrdenCompraStore } from '../../../stores/orden-compra.store';
import { OrdenCompraEntity } from '../../../domain/models/orden-compra.entity';

/**
 * Caso de uso: Guardar Orden de Compra
 * Guarda una nueva orden de compra y actualiza el store
 */
@Injectable()
export class GuardarOrdenCompraUseCase {
  private readonly repository = inject(IOrdenCompraRepository);
  private readonly store = inject(OrdenCompraStore);

  execute(ordenCompra: OrdenCompraEntity) {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);

    return this.repository.guardarOrdenCompra(ordenCompra).pipe(
      tap((ordenGuardada) => {
        this.store.agregarOrdenCompra(ordenGuardada);
        console.log('  Orden de compra guardada:', ordenGuardada.orden_compra_numero);
      }),
      catchError((error) => {
        const errorMsg = 'Error al guardar orden de compra';
        this.store.setErrorGuardar(errorMsg);
        console.error(errorMsg, error);
        return of(null);
      }),
      finalize(() => {
        this.store.setLoadingGuardar(false);
      })
    );
  }
}
