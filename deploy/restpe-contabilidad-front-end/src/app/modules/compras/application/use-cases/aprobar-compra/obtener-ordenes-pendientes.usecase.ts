import { Injectable, inject } from '@angular/core';
import { Observable, tap, catchError, finalize, of } from 'rxjs';
import { IAprobarCompraRepository } from '../../../domain/repositories/iaprobar-compra.repository';
import { OrdenCompraEntity } from '../../../domain/models/orden-compra.entity';
import { AprobarCompraStore } from '../../../stores/aprobar-compra.store';

/**
 * Use Case: Obtener Órdenes Pendientes de Aprobación
 * Application Layer - Single Responsibility
 */
@Injectable()
export class ObtenerOrdenesPendientesUseCase {
  private readonly repository = inject(IAprobarCompraRepository);
  private readonly store = inject(AprobarCompraStore);

  execute(): Observable<OrdenCompraEntity[]> {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    return this.repository.obtenerOrdenesPendientes().pipe(
      tap(ordenes => {
        this.store.setOrdenesPendientes(ordenes);
      }),
      catchError(err => {
        const msg = err?.message ?? 'Error al obtener las órdenes pendientes';
        this.store.setErrorObtener(msg);
        return of([]);
      }),
      finalize(() => {
        this.store.setLoadingObtener(false);
      })
    );
  }
}
