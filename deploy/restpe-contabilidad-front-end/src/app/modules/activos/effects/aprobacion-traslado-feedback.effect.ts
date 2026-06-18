import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { AprobacionTrasladoStore } from '../store/aprobacion-traslado.store';

@Injectable()
export class AprobacionTrasladoFeedbackEffects {
  private readonly store        = inject(AprobacionTrasladoStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.toastService.success('Traslado guardado correctamente');
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.toastService.success('Traslado actualizado correctamente');
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.toastService.success('Traslado eliminado correctamente');
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
