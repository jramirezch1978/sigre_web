import { Injectable, inject, effect } from '@angular/core';
import { AprobarCompraStore } from '../stores/aprobar-compra.store';
import { ObtenerOrdenesPendientesUseCase } from '../application/use-cases/aprobar-compra/obtener-ordenes-pendientes.usecase';

/**
 * Effects de sincronización para el flujo de Aprobación de Compras
 * Recarga las órdenes pendientes automáticamente tras cada operación de estado
 */
@Injectable()
export class AprobarCompraSyncEffects {
  private readonly store = inject(AprobarCompraStore);
  private readonly obtenerPendientesUseCase = inject(ObtenerOrdenesPendientesUseCase);

  constructor() {
    let previousLoadingAprobar  = false;
    let previousLoadingRechazar = false;
    let previousLoadingRetornar = false;

    // Sync: recargar órdenes pendientes después de aprobar
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
