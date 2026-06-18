import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { GeneracionAsientosRevaluacionStore } from '../store/generacion-asientos-revaluacion.store';

@Injectable()
export class GeneracionAsientosRevaluacionFeedbackEffects {
  private readonly store        = inject(GeneracionAsientosRevaluacionStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.toastService.success('Asiento de revaluación guardado correctamente');
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.toastService.success('Asiento de revaluación actualizado correctamente');
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.toastService.success('Asiento de revaluación eliminado correctamente');
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
