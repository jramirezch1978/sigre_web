import { Injectable, inject } from '@angular/core';
import { Observable, tap, catchError, finalize, of } from 'rxjs';
import { IAprobarServicioRepository } from '../../../domain/repositories/iaprobar-servicio.repository';
import { OrdenServicioEntity } from '../../../domain/models/orden-servicio.entity';
import { AprobarServicioStore } from '../../../stores/aprobar-servicio.store';

/**
 * Use Case: Obtener Órdenes de Servicio Pendientes de Aprobación
 * Application Layer - Single Responsibility
 */
@Injectable()
export class ObtenerOrdenesServicioPendientesUseCase {
  private readonly repository = inject(IAprobarServicioRepository);
  private readonly store = inject(AprobarServicioStore);

  execute(): Observable<OrdenServicioEntity[]> {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    return this.repository.obtenerOrdenesPendientes().pipe(
      tap(ordenes => {
        this.store.setOrdenesPendientes(ordenes);
      }),
      catchError(err => {
        const msg = err?.message ?? 'Error al obtener las órdenes de servicio pendientes';
        this.store.setErrorObtener(msg);
        return of([]);
      }),
      finalize(() => {
        this.store.setLoadingObtener(false);
      })
    );
  }
}
