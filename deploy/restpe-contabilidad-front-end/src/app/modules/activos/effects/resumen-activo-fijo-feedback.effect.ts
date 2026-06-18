import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ResumenActivoFijoStore } from '../store/resumen-activo-fijo.store';

@Injectable()
export class ResumenActivoFijoFeedbackEffects {
  private readonly store        = inject(ResumenActivoFijoStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.toastService.success('Resumen de activo fijo guardado correctamente');
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
        this.toastService.success('Resumen de activo fijo actualizado correctamente');
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
        this.toastService.success('Resumen de activo fijo eliminado correctamente');
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
