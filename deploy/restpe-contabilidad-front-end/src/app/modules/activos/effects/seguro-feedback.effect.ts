import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { SeguroStore } from '../store/seguro.store';

@Injectable()
export class SeguroFeedbackEffects {
  private readonly store        = inject(SeguroStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.toastService.success('Tipo de seguro guardado correctamente');
      }
    });

    effect(() => {
      const error = this.store.errorGuardar();
      if (error) {
        this.toastService.danger(error);
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.toastService.success('Tipo de seguro actualizado correctamente');
      }
    });

    effect(() => {
      const error = this.store.errorActualizar();
      if (error) {
        this.toastService.danger(error);
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.toastService.success('Tipo de seguro eliminado correctamente');
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
