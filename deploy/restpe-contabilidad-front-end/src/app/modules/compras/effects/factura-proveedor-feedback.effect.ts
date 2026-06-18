import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FacturaProveedorStore } from '../stores/factura-proveedor.store';

/**
 * Effects de feedback (toasts) para Facturas de Proveedor
 * Se activan automáticamente al detectar transiciones en el store
 */
@Injectable()
export class FacturaProveedorFeedbackEffects {
  private readonly store = inject(FacturaProveedorStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    let previousLoadingGuardar = false;
    let previousLoadingActualizar = false;
    let previousLoadingEliminar = false;

    // Effect: Toast al guardar
    effect(() => {
      const isLoading = this.store.loadingGuardar();
      const error = this.store.errorGuardar();

      if (previousLoadingGuardar && !isLoading) {
        if (error) {
          this.toastService.danger('Error al guardar la factura: ' + error);
        } else {
          this.toastService.success('¡Factura guardada exitosamente!');
        }
      }
      previousLoadingGuardar = isLoading;
    });

    // Effect: Toast al actualizar
    effect(() => {
      const isLoading = this.store.loadingActualizar();
      const error = this.store.errorActualizar();

      if (previousLoadingActualizar && !isLoading) {
        if (error) {
          this.toastService.danger('Error al actualizar la factura: ' + error);
        } else {
          this.toastService.success('¡Factura actualizada exitosamente!');
        }
      }
      previousLoadingActualizar = isLoading;
    });

    // Effect: Toast al eliminar
    effect(() => {
      const isLoading = this.store.loadingEliminar();
      const error = this.store.errorEliminar();

      if (previousLoadingEliminar && !isLoading) {
        if (error) {
          this.toastService.danger('Error al eliminar la factura: ' + error);
        } else {
          this.toastService.success('Factura eliminada exitosamente');
        }
      }
      previousLoadingEliminar = isLoading;
    });
  }
}
