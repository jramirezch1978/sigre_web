import { Injectable, inject } from '@angular/core';
import { Observable, tap, catchError, finalize, of } from 'rxjs';
import { IAprobarCompraRepository } from '../../../domain/repositories/iaprobar-compra.repository';
import { OrdenCompraEntity } from '../../../domain/models/orden-compra.entity';
import { ApiResponse } from '../../../../../shared/models/api-response.model';
import { AprobarCompraStore } from '../../../stores/aprobar-compra.store';

/**
 * Use Case: Retornar una Orden de Compra
 * Application Layer - Single Responsibility
 */
@Injectable()
export class RetornarOrdenUseCase {
  private readonly repository = inject(IAprobarCompraRepository);
  private readonly store = inject(AprobarCompraStore);

  execute(numeroOrden: string, motivo: string): Observable<ApiResponse<OrdenCompraEntity>> {
    this.store.setLoadingRetornar(true);
    this.store.setErrorRetornar(null);

    return this.repository.retornarOrden(numeroOrden, motivo).pipe(
      tap(response => {
        if (response.success) {
          this.store.removerOrdenPendiente(numeroOrden);
        }
      }),
      catchError(err => {
        const msg = err?.message ?? 'Error al retornar la orden de compra';
        this.store.setErrorRetornar(msg);
        return of({ success: false, message: msg, data: null as any });
      }),
      finalize(() => {
        this.store.setLoadingRetornar(false);
      })
    );
  }
}
