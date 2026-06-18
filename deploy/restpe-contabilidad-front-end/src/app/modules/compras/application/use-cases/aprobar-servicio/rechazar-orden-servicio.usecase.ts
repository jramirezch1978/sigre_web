import { Injectable, inject } from '@angular/core';
import { Observable, tap, catchError, finalize, of } from 'rxjs';
import { IAprobarServicioRepository } from '../../../domain/repositories/iaprobar-servicio.repository';
import { OrdenServicioEntity } from '../../../domain/models/orden-servicio.entity';
import { ApiResponse } from '../../../../../shared/models/api-response.model';
import { AprobarServicioStore } from '../../../stores/aprobar-servicio.store';

/**
 * Use Case: Rechazar una Orden de Servicio
 * Application Layer - Single Responsibility
 */
@Injectable()
export class RechazarOrdenServicioUseCase {
  private readonly repository = inject(IAprobarServicioRepository);
  private readonly store = inject(AprobarServicioStore);

  execute(numeroOrden: string, motivo: string): Observable<ApiResponse<OrdenServicioEntity>> {
    this.store.setLoadingRechazar(true);
    this.store.setErrorRechazar(null);

    return this.repository.rechazarOrden(numeroOrden, motivo).pipe(
      tap(response => {
        if (response.success) {
          this.store.removerOrdenPendiente(numeroOrden);
        }
      }),
      catchError(err => {
        const msg = err?.message ?? 'Error al rechazar la orden de servicio';
        this.store.setErrorRechazar(msg);
        return of({ success: false, message: msg, data: null as any });
      }),
      finalize(() => {
        this.store.setLoadingRechazar(false);
      })
    );
  }
}
