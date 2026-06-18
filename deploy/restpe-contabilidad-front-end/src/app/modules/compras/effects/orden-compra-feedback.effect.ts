import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { OrdenCompraStore } from '../stores/orden-compra.store';

/**
 * Effect: Feedback de Órdenes de Compra
 * Muestra toasts cuando hay éxito o error en las operaciones
 */
@Injectable()
export class OrdenCompraFeedbackEffects {
  private readonly toastService = inject(ToastService);
  private readonly store = inject(OrdenCompraStore);

  constructor() {
    // Effect para éxito al guardar
    effect(() => {
      const loading = this.store.loadingGuardar();
      const error = this.store.errorGuardar();
      const ordenes = this.store.ordenesCompra();

      // Solo mostrar toast cuando termine de cargar y no haya error
      if (!loading && !error && ordenes.length > 0) {
        // Usamos un flag temporal para evitar mostrar el toast en la carga inicial
        const isInitialLoad = ordenes.length === 0;
        if (!isInitialLoad) {
          // this.toastService.success('Orden de compra guardada exitosamente');
        }
      }
    });

    // Effect para error al guardar
    effect(() => {
      const error = this.store.errorGuardar();
      if (error) {
        this.toastService.danger(error);
      }
    });

    // Effect para éxito al actualizar
    effect(() => {
      const loading = this.store.loadingActualizar();
      const error = this.store.errorActualizar();

      if (!loading && !error) {
        // Solo mostrar si hubo una actualización real
        const wasUpdating = loading === false;
        if (wasUpdating) {
          // this.toastService.success('Orden de compra actualizada exitosamente');
        }
      }
    });

    // Effect para error al actualizar
    effect(() => {
      const error = this.store.errorActualizar();
      if (error) {
        this.toastService.danger(error);
      }
    });

    // Effect para éxito al eliminar
    effect(() => {
      const loading = this.store.loadingEliminar();
      const error = this.store.errorEliminar();

      if (!loading && !error) {
        const wasDeleting = loading === false;
        if (wasDeleting) {
          // this.toastService.success('Orden de compra eliminada exitosamente');
        }
      }
    });

    // Effect para error al eliminar
    effect(() => {
      const error = this.store.errorEliminar();
      if (error) {
        this.toastService.danger(error);
      }
    });

    // Effect para error al obtener
    effect(() => {
      const error = this.store.errorObtener();
      if (error) {
        this.toastService.danger(error);
      }
    });
  }
}
