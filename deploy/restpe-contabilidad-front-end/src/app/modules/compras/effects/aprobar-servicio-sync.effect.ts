import { Injectable, inject, effect } from '@angular/core';
import { AprobarServicioStore } from '../stores/aprobar-servicio.store';
import { ObtenerOrdenesServicioPendientesUseCase } from '../application/use-cases/aprobar-servicio/obtener-ordenes-servicio-pendientes.usecase';

/**
 * Effects de sincronización para el flujo de Aprobación de Servicios
 * Recarga las órdenes de servicio pendientes automáticamente tras cada operación de estado
 */
@Injectable()
export class AprobarServicioSyncEffects {
  private readonly store = inject(AprobarServicioStore);
  private readonly obtenerPendientesUseCase = inject(ObtenerOrdenesServicioPendientesUseCase);

  constructor() {
    let previousLoadingAprobar  = false;
    let previousLoadingRechazar = false;
    let previousLoadingRetornar = false;

    // Sync: recargar órdenes de servicio pendientes después de aprobar
    effect(() => {
      const isLoading = this.store.loadingAprobar();
      const error     = this.store.errorAprobar();

      if (previousLoadingAprobar && !isLoading && !error) {
        this.obtenerPendientesUseCase.execute().subscribe();
      }
      previousLoadingAprobar = isLoading;
    });

    // Sync: recargar tras rechazar
    effect(() => {
      const isLoading = this.store.loadingRechazar();
      const error     = this.store.errorRechazar();

      if (previousLoadingRechazar && !isLoading && !error) {
        this.obtenerPendientesUseCase.execute().subscribe();
      }
      previousLoadingRechazar = isLoading;
    });

    // Sync: recargar tras retornar
    effect(() => {
      const isLoading = this.store.loadingRetornar();
      const error     = this.store.errorRetornar();

      if (previousLoadingRetornar && !isLoading && !error) {
        this.obtenerPendientesUseCase.execute().subscribe();
      }
      previousLoadingRetornar = isLoading;
    });
  }
}
