import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IOrdenCompraRepository } from '../../../domain/repositories/iorden-compra.repository';
import { OrdenCompraStore } from '../../../stores/orden-compra.store';

/**
 * Caso de uso: Obtener Órdenes de Compra
 * Obtiene todas las órdenes de compra desde el repositorio y actualiza el store
 */
@Injectable()
export class ObtenerOrdenesCompraUseCase {
  private readonly repository = inject(IOrdenCompraRepository);
  private readonly store = inject(OrdenCompraStore);

  execute() {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    return this.repository.obtenerOrdenesCompra().pipe(
      tap((ordenes) => {
        this.store.setOrdenesCompra(ordenes);
        console.log('  Órdenes de compra cargadas:', ordenes.length);
      }),
      catchError((error) => {
        const errorMsg = 'Error al obtener órdenes de compra';
        this.store.setErrorObtener(errorMsg);
        console.error(errorMsg, error);
        return of([]);
      }),
      finalize(() => {
        this.store.setLoadingObtener(false);
      })
    );
  }
}
