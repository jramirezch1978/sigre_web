import { Injectable, inject, effect } from '@angular/core';
import { OrdenServicioStore } from '../stores/orden-servicio.store';
import { ObtenerOrdenesServicioUseCase } from '../application/use-cases/orden-servicio/obtener-ordenes-servicio.usecase';

/**
 * Effect: Sincronización de Órdenes de Servicio
 * Auto-recarga las órdenes después de guardar, actualizar o eliminar
 */
@Injectable()
export class OrdenServicioSyncEffects {
  private readonly store = inject(OrdenServicioStore);
  private readonly obtenerOrdenesUseCase = inject(ObtenerOrdenesServicioUseCase);

  // Banderas para evitar recargas duplicadas
  private previousLoadingGuardar = false;
  private previousLoadingActualizar = false;
  private previousLoadingEliminar = false;

  constructor() {
    // Effect para recargar después de guardar
    effect(() => {
      const loading = this.store.loadingGuardar();
      const error = this.store.errorGuardar();

      // Detectar transición de loading: true -> false sin error
      if (this.previousLoadingGuardar && !loading && !error) {
        console.log('  Auto-recarga después de guardar orden de servicio');
        this.obtenerOrdenesUseCase.execute().subscribe();
      }

      this.previousLoadingGuardar = loading;
    });

    // Effect para recargar después de actualizar
    effect(() => {
      const loading = this.store.loadingActualizar();
      const error = this.store.errorActualizar();

      if (this.previousLoadingActualizar && !loading && !error) {
        console.log('  Auto-recarga después de actualizar orden de servicio');
        this.obtenerOrdenesUseCase.execute().subscribe();
      }

      this.previousLoadingActualizar = loading;
    });

    // Effect para recargar después de eliminar
    effect(() => {
      const loading = this.store.loadingEliminar();
      const error = this.store.errorEliminar();

      if (this.previousLoadingEliminar && !loading && !error) {
        console.log('  Auto-recarga después de eliminar orden de servicio');
        this.obtenerOrdenesUseCase.execute().subscribe();
      }

      this.previousLoadingEliminar = loading;
    });
  }
}
