import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { GeneracionAsientosIndexacionStore } from '../store/generacion-asientos-indexacion.store';

/**
 * Efectos de feedback visual (toasts) para Generación de Asientos de Indexación.
 * Reacciona a cambios en resultados y errores del store.
 */
@Injectable()
export class GeneracionAsientosIndexacionFeedbackEffects {
  private readonly store        = inject(GeneracionAsientosIndexacionStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.toastService.success('Asiento de indexación guardado correctamente');
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.toastService.success('Asiento de indexación actualizado correctamente');
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.toastService.success('Asiento de indexación eliminado correctamente');
      }
    });

    effect(() => {
      const error = this.store.errorGuardar();
      if (error) this.toastService.danger(error);
    });

    effect(() => {
      const error = this.store.errorActualizar();
      if (error) this.toastService.danger(error);
    });

    effect(() => {
      const error = this.store.errorEliminar();
      if (error) this.toastService.danger(error);
    });
  }
}
