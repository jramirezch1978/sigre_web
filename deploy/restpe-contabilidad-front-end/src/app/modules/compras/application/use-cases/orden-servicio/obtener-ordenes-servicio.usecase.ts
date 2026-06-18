import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IOrdenServicioRepository } from '../../../domain/repositories/iorden-servicio.repository';
import { OrdenServicioStore } from '../../../stores/orden-servicio.store';

/**
 * Caso de uso: Obtener Órdenes de Servicio
 * Obtiene todas las órdenes de servicio desde el repositorio y actualiza el store
 */
@Injectable()
export class ObtenerOrdenesServicioUseCase {
  private readonly repository = inject(IOrdenServicioRepository);
  private readonly store = inject(OrdenServicioStore);

  execute() {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    return this.repository.obtenerOrdenesServicio().pipe(
      tap((ordenes) => {
        this.store.setOrdenesServicio(ordenes);
        console.log('  Órdenes de servicio cargadas:', ordenes.length);
      }),
      catchError((error) => {
        const errorMsg = 'Error al obtener órdenes de servicio';
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
