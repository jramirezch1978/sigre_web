import { Injectable, inject, effect } from '@angular/core';
import { OrdenCompraStore } from '../stores/orden-compra.store';
import { ObtenerOrdenesCompraUseCase } from '../application/use-cases/orden-compra/obtener-ordenes-compra.usecase';

/**
 * Effect: Sincronización de Órdenes de Compra
 * Auto-recarga las órdenes después de guardar, actualizar o eliminar
 */
@Injectable()
export class OrdenCompraSyncEffects {
  private readonly store = inject(OrdenCompraStore);
  private readonly obtenerOrdenesUseCase = inject(ObtenerOrdenesCompraUseCase);

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
        console.log('  Auto-recarga después de guardar orden de compra');
        this.obtenerOrdenesUseCase.execute().subscribe();
      }

      this.previousLoadingGuardar = loading;
    });

    // Effect para recargar después de actualizar
    effect(() => {
      const loading = this.store.loadingActualizar();
      const error = this.store.errorActualizar();

      if (this.previousLoadingActualizar && !loading && !error) {
        console.log('  Auto-recarga después de actualizar orden de compra');
        this.obtenerOrdenesUseCase.execute().subscribe();
      }

      this.previousLoadingActualizar = loading;
    });

    // Effect para recargar después de eliminar
    effect(() => {
      const loading = this.store.loadingEliminar();
      const error = this.store.errorEliminar();

      if (this.previousLoadingEliminar && !loading && !error) {
        console.log('  Auto-recarga después de eliminar orden de compra');
        this.obtenerOrdenesUseCase.execute().subscribe();
      }

      this.previousLoadingEliminar = loading;
    });
  }
}
