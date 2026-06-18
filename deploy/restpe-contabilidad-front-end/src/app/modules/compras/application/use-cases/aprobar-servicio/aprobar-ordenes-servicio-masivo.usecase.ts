import { Injectable, inject } from '@angular/core';
import { Observable, tap, catchError, finalize, of } from 'rxjs';
import { IAprobarServicioRepository } from '../../../domain/repositories/iaprobar-servicio.repository';
import { OrdenServicioEntity } from '../../../domain/models/orden-servicio.entity';
import { ApiResponse } from '../../../../../shared/models/api-response.model';
import { AprobarServicioStore } from '../../../stores/aprobar-servicio.store';

/**
 * Use Case: Aprobar múltiples órdenes de servicio en bloque
 * Application Layer - Single Responsibility
 */
@Injectable()
export class AprobarOrdenesServicioMasivoUseCase {
  private readonly repository = inject(IAprobarServicioRepository);
  private readonly store = inject(AprobarServicioStore);

  execute(numerosOrden: string[]): Observable<ApiResponse<OrdenServicioEntity[]>> {
    this.store.setLoadingAprobar(true);
    this.store.setErrorAprobar(null);

    return this.repository.aprobarOrdenesMasivo(numerosOrden).pipe(
      tap(response => {
        if (response.success) {
          numerosOrden.forEach(n => this.store.removerOrdenPendiente(n));
        }
      }),
      catchError(err => {
        const msg = err?.message ?? 'Error al aprobar las órdenes de servicio';
        this.store.setErrorAprobar(msg);
        return of({ success: false, message: msg, data: [] });
      }),
      finalize(() => {
        this.store.setLoadingAprobar(false);
      })
    );
  }
}
