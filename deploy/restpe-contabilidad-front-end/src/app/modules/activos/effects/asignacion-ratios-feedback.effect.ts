import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { AsignacionRatiosStore } from '../store/asignacion-ratios.store';

@Injectable()
export class AsignacionRatiosFeedbackEffects {
  private readonly store        = inject(AsignacionRatiosStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.toastService.success('Asignación guardada correctamente');
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.toastService.success('Asignación actualizada correctamente');
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.toastService.success('Asignación eliminada correctamente');
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
