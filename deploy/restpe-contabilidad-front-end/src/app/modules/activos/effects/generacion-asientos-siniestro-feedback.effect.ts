import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { GeneracionAsientosSiniestroStore } from '../store/generacion-asientos-siniestro.store';

@Injectable()
export class GeneracionAsientosSiniestroFeedbackEffects {
  private readonly store        = inject(GeneracionAsientosSiniestroStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.toastService.success('Siniestro guardado correctamente');
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.toastService.success('Siniestro actualizado correctamente');
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.toastService.success('Siniestro eliminado correctamente');
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
