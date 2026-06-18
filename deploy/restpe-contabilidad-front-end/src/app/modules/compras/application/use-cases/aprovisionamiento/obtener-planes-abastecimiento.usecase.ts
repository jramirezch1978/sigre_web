import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IAprovisionamientoRepository } from '../../../domain/repositories/iaprovisionamiento.repository';
import { AprovisionamientoStore } from '../../../stores/aprovisionamiento.store';

/**
 * Caso de uso: Obtener Planes de Abastecimiento
 * Obtiene todos los planes desde el repositorio y actualiza el store
 */
@Injectable()
export class ObtenerPlanesAbastecimientoUseCase {
  private readonly repository = inject(IAprovisionamientoRepository);
  private readonly store = inject(AprovisionamientoStore);

  execute() {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    return this.repository.obtenerPlanes().pipe(
      tap((planes) => {
        this.store.setPlanes(planes);
        console.log('  Planes de abastecimiento cargados:', planes.length);
      }),
      catchError((error) => {
        const errorMsg = 'Error al obtener planes de abastecimiento';
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
