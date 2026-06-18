import { Injectable, inject } from '@angular/core';
import { Observable, tap, catchError, finalize, of } from 'rxjs';
import { IAprobarCompraRepository } from '../../../domain/repositories/iaprobar-compra.repository';
import { OrdenCompraEntity } from '../../../domain/models/orden-compra.entity';
import { ApiResponse } from '../../../../../shared/models/api-response.model';
import { AprobarCompraStore } from '../../../stores/aprobar-compra.store';

/**
 * Use Case: Aprobar múltiples órdenes de compra en bloque
 * Application Layer - Single Responsibility
 */
@Injectable()
export class AprobarOrdenesMasivoUseCase {
  private readonly repository = inject(IAprobarCompraRepository);
  private readonly store = inject(AprobarCompraStore);

  execute(numerosOrden: string[]): Observable<ApiResponse<OrdenCompraEntity[]>> {
    this.store.setLoadingAprobar(true);
    this.store.setErrorAprobar(null);

    return this.repository.aprobarOrdenesMasivo(numerosOrden).pipe(
      tap(response => {
        if (response.success) {
          numerosOrden.forEach(n => this.store.removerOrdenPendiente(n));
        }
      }),
      catchError(err => {
        const msg = err?.message ?? 'Error al aprobar las órdenes de compra';
        this.store.setErrorAprobar(msg);
        return of({ success: false, message: msg, data: [] });
      }),
      finalize(() => {
        this.store.setLoadingAprobar(false);
      })
    );
  }
}
