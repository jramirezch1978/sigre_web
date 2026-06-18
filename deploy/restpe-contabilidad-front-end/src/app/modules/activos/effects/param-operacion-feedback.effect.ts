import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ParamOperacionStore } from '../store/param-operacion.store';

/**
 * Effects de feedback para Parámetros de Operaciones de Activos Fijos.
 * Muestra toasts de éxito/error tras cada operación CRUD.
 */
@Injectable()
export class ParamOperacionFeedbackEffects {
  private readonly store        = inject(ParamOperacionStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    // Feedback guardar
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.toastService.success('Parámetros de operaciones guardados correctamente');
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
        this.toastService.success('Parámetros de operaciones actualizados correctamente');
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
        this.toastService.success('Parámetros de operaciones eliminados correctamente');
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
