import { Injectable, inject } from '@angular/core';
import { Observable, tap, catchError, finalize, of } from 'rxjs';
import { IAprobarServicioRepository } from '../../../domain/repositories/iaprobar-servicio.repository';
import { OrdenServicioEntity } from '../../../domain/models/orden-servicio.entity';
import { ApiResponse } from '../../../../../shared/models/api-response.model';
import { AprobarServicioStore } from '../../../stores/aprobar-servicio.store';

/**
 * Use Case: Retornar una Orden de Servicio
 * Application Layer - Single Responsibility
 */
@Injectable()
export class RetornarOrdenServicioUseCase {
  private readonly repository = inject(IAprobarServicioRepository);
  private readonly store = inject(AprobarServicioStore);

  execute(numeroOrden: string, motivo: string): Observable<ApiResponse<OrdenServicioEntity>> {
    this.store.setLoadingRetornar(true);
    this.store.setErrorRetornar(null);

    return this.repository.retornarOrden(numeroOrden, motivo).pipe(
      tap(response => {
        if (response.success) {
          this.store.removerOrdenPendiente(numeroOrden);
        }
      }),
      catchError(err => {
        const msg = err?.message ?? 'Error al retornar la orden de servicio';
        this.store.setErrorRetornar(msg);
        return of({ success: false, message: msg, data: null as any });
      }),
      finalize(() => {
        this.store.setLoadingRetornar(false);
      })
    );
  }
}
