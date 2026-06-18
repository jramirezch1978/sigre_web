import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { IncidenciaStore } from '../store/incidencia.store';

/**
 * Effect que escucha resultados/errores de operaciones de Incidencias
 * y lanza notificaciones toast al usuario.
 */
@Injectable()
export class IncidenciaFeedbackEffects {
  private readonly store        = inject(IncidenciaStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    // Feedback guardar
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.toastService.success('Incidencia guardada correctamente');
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
        this.toastService.success('Incidencia actualizada correctamente');
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
        this.toastService.success('Incidencia eliminada correctamente');
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
