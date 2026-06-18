import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { IOrdenServicioRepository } from '../../../domain/repositories/iorden-servicio.repository';
import { OrdenServicioStore } from '../../../stores/orden-servicio.store';
import { OrdenServicioEntity } from '../../../domain/models/orden-servicio.entity';

/**
 * Caso de uso: Guardar Orden de Servicio
 * Guarda una nueva orden de servicio y actualiza el store
 */
@Injectable()
export class GuardarOrdenServicioUseCase {
  private readonly repository = inject(IOrdenServicioRepository);
  private readonly store = inject(OrdenServicioStore);

  execute(ordenServicio: OrdenServicioEntity) {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);

    return this.repository.guardarOrdenServicio(ordenServicio).pipe(
      tap((ordenGuardada) => {
        this.store.agregarOrdenServicio(ordenGuardada);
        console.log('  Orden de servicio guardada:', ordenGuardada.orden_servicio_numero);
      }),
      catchError((error) => {
        const errorMsg = 'Error al guardar orden de servicio';
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
