import { Injectable, inject } from '@angular/core';
import { Observable, tap, catchError, finalize, of } from 'rxjs';
import { IAprobarServicioRepository } from '../../../domain/repositories/iaprobar-servicio.repository';
import { OrdenServicioEntity } from '../../../domain/models/orden-servicio.entity';
import { ApiResponse } from '../../../../../shared/models/api-response.model';
import { AprobarServicioStore } from '../../../stores/aprobar-servicio.store';

/**
 * Use Case: Aprobar una Orden de Servicio
 * Application Layer - Single Responsibility
 */
@Injectable()
export class AprobarOrdenServicioUseCase {
  private readonly repository = inject(IAprobarServicioRepository);
  private readonly store = inject(AprobarServicioStore);

  execute(numeroOrden: string): Observable<ApiResponse<OrdenServicioEntity>> {
    this.store.setLoadingAprobar(true);
    this.store.setErrorAprobar(null);

    return this.repository.aprobarOrden(numeroOrden).pipe(
      tap(response => {
        if (response.success && response.data) {
          // Remover la orden de la lista de pendientes tras aprobarla
          this.store.removerOrdenPendiente(numeroOrden);
        }
      }),
      catchError(err => {
        const msg = err?.message ?? 'Error al aprobar la orden de servicio';
        this.store.setErrorAprobar(msg);
        return of({ success: false, message: msg, data: null as any });
      }),
      finalize(() => {
        this.store.setLoadingAprobar(false);
      })
    );
  }
}
