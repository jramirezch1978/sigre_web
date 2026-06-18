import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { OrdenServicioStore } from '../stores/orden-servicio.store';

/**
 * Effect: Feedback de Órdenes de Servicio
 * Muestra toasts cuando hay éxito o error en las operaciones
 */
@Injectable()
export class OrdenServicioFeedbackEffects {
  private readonly toastService = inject(ToastService);
  private readonly store = inject(OrdenServicioStore);

  // Flags para detectar transición true → false (operación real completada)
  private wasLoadingGuardar = false;
  private wasLoadingActualizar = false;
  private wasLoadingEliminar = false;

  constructor() {
    // Effect para éxito al guardar (solo dispara cuando loading pasa de true → false)
    effect(() => {
      const loading = this.store.loadingGuardar();
      const error = this.store.errorGuardar();

      if (this.wasLoadingGuardar && !loading && !error) {
        this.toastService.success('Orden de servicio guardada exitosamente');
      }
      this.wasLoadingGuardar = loading;
    });

    // Effect para error al guardar
    effect(() => {
      const error = this.store.errorGuardar();
      if (error) {
        this.toastService.danger(error);
      }
    });

    // Effect para éxito al actualizar (solo dispara cuando loading pasa de true → false)
    effect(() => {
      const loading = this.store.loadingActualizar();
      const error = this.store.errorActualizar();

      if (this.wasLoadingActualizar && !loading && !error) {
        this.toastService.success('Orden de servicio actualizada exitosamente');
      }
      this.wasLoadingActualizar = loading;
    });

    // Effect para error al actualizar
    effect(() => {
      const error = this.store.errorActualizar();
      if (error) {
        this.toastService.danger(error);
      }
    });

    // Effect para éxito al eliminar (solo dispara cuando loading pasa de true → false)
    effect(() => {
      const loading = this.store.loadingEliminar();
      const error = this.store.errorEliminar();

      if (this.wasLoadingEliminar && !loading && !error) {
        this.toastService.success('Orden de servicio eliminada exitosamente');
      }
      this.wasLoadingEliminar = loading;
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
