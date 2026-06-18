import { Injectable, inject } from '@angular/core';
import { Observable, tap, catchError, finalize, of } from 'rxjs';
import { IAprobarCompraRepository } from '../../../domain/repositories/iaprobar-compra.repository';
import { OrdenCompraEntity } from '../../../domain/models/orden-compra.entity';
import { ApiResponse } from '../../../../../shared/models/api-response.model';
import { AprobarCompraStore } from '../../../stores/aprobar-compra.store';

/**
 * Use Case: Aprobar una Orden de Compra
 * Application Layer - Single Responsibility
 */
@Injectable()
export class AprobarOrdenUseCase {
  private readonly repository = inject(IAprobarCompraRepository);
  private readonly store = inject(AprobarCompraStore);

  execute(numeroOrden: string, observacion?: string): Observable<ApiResponse<OrdenCompraEntity>> {
    this.store.setLoadingAprobar(true);
    this.store.setErrorAprobar(null);

    return this.repository.aprobarOrden(numeroOrden, observacion).pipe(
      tap(response => {
        if (response.success && response.data) {
          // Remover la orden de la lista de pendientes tras aprobarla
          this.store.removerOrdenPendiente(numeroOrden);
        }
      }),
      catchError(err => {
        const msg = err?.message ?? 'Error al aprobar la orden de compra';
        this.store.setErrorAprobar(msg);
        return of({ success: false, message: msg, data: null as any });
      }),
      finalize(() => {
        this.store.setLoadingAprobar(false);
      })
    );
  }
}
