import { Injectable, inject, effect } from '@angular/core';
import { FacturaProveedorStore } from '../stores/factura-proveedor.store';
import { ObtenerFacturasProveedorUseCase } from '../application/use-cases/factura-proveedor/obtener-facturas-proveedor.usecase';

/**
 * Effects de sincronización para Facturas de Proveedor
 * Recarga automáticamente la lista tras operaciones CRUD exitosas
 */
@Injectable()
export class FacturaProveedorSyncEffects {
  private readonly store = inject(FacturaProveedorStore);
  private readonly obtenerUseCase = inject(ObtenerFacturasProveedorUseCase);

  constructor() {
    let previousLoadingGuardar = false;
    let previousLoadingActualizar = false;
    let previousLoadingEliminar = false;

    // Effect: Recargar tras guardar
    effect(() => {
      const isLoading = this.store.loadingGuardar();
      const error = this.store.errorGuardar();

      if (previousLoadingGuardar && !isLoading && !error) {
        this.recargarFacturas();
      }
      previousLoadingGuardar = isLoading;
    });

    // Effect: Recargar tras actualizar
    effect(() => {
      const isLoading = this.store.loadingActualizar();
      const error = this.store.errorActualizar();

      if (previousLoadingActualizar && !isLoading && !error) {
        this.recargarFacturas();
      }
      previousLoadingActualizar = isLoading;
    });

    // Effect: Recargar tras eliminar
    effect(() => {
      const isLoading = this.store.loadingEliminar();
      const error = this.store.errorEliminar();

      if (previousLoadingEliminar && !isLoading && !error) {
        this.recargarFacturas();
      }
      previousLoadingEliminar = isLoading;
    });
  }

  private recargarFacturas(): void {
    this.store.setLoadingObtener(true);
    this.obtenerUseCase.execute().subscribe({
      next: facturas => this.store.setFacturas(facturas),
      error: err => this.store.setErrorObtener(err.message),
      complete: () => this.store.setLoadingObtener(false),
    });
  }
}
