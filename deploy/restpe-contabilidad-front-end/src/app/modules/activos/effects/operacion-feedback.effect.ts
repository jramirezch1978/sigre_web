import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { OperacionStore } from '../store/operacion.store';

/**
 * Effects de feedback para Operaciones de Activos Fijos.
 * Muestra toasts de éxito/error tras cada operación CRUD.
 */
@Injectable()
export class OperacionFeedbackEffects {
  private readonly store        = inject(OperacionStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    // Feedback guardar
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.toastService.success('Operación guardada correctamente');
      }
    });

    effect(() => {
      const error = this.store.errorGuardar();
      if (error) {
        this.toastService.danger(error);
      }
    });

    // Feedback actualizar
    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.toastService.success('Operación actualizada correctamente');
      }
    });

    effect(() => {
      const error = this.store.errorActualizar();
      if (error) {
        this.toastService.danger(error);
      }
    });

    // Feedback eliminar
    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.toastService.success('Operación eliminada correctamente');
      }
    });

    effect(() => {
      const error = this.store.errorEliminar();
      if (error) {
        this.toastService.danger(error);
      }
    });
  }
}
