import { Injectable, inject } from '@angular/core';
import { Observable, tap, catchError, finalize, of } from 'rxjs';
import { IAprobarCompraRepository } from '../../../domain/repositories/iaprobar-compra.repository';
import { OrdenCompraEntity } from '../../../domain/models/orden-compra.entity';
import { ApiResponse } from '../../../../../shared/models/api-response.model';
import { AprobarCompraStore } from '../../../stores/aprobar-compra.store';

/**
 * Use Case: Rechazar una Orden de Compra
 * Application Layer - Single Responsibility
 */
@Injectable()
export class RechazarOrdenUseCase {
  private readonly repository = inject(IAprobarCompraRepository);
  private readonly store = inject(AprobarCompraStore);

  execute(numeroOrden: string, motivo: string): Observable<ApiResponse<OrdenCompraEntity>> {
    this.store.setLoadingRechazar(true);
    this.store.setErrorRechazar(null);

    return this.repository.rechazarOrden(numeroOrden, motivo).pipe(
      tap(response => {
        if (response.success) {
          this.store.removerOrdenPendiente(numeroOrden);
        }
      }),
      catchError(err => {
        const msg = err?.message ?? 'Error al rechazar la orden de compra';
        this.store.setErrorRechazar(msg);
        return of({ success: false, message: msg, data: null as any });
      }),
      finalize(() => {
        this.store.setLoadingRechazar(false);
      })
    );
  }
}
