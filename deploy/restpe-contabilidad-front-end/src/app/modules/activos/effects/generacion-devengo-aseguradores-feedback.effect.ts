import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { GeneracionDevengoAseguradoresStore } from '../store/generacion-devengo-aseguradores.store';

@Injectable()
export class GeneracionDevengoAseguradoresFeedbackEffects {
  private readonly store        = inject(GeneracionDevengoAseguradoresStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.toastService.success('Devengo guardado correctamente');
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.toastService.success('Devengo actualizado correctamente');
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.toastService.success('Devengo eliminado correctamente');
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
