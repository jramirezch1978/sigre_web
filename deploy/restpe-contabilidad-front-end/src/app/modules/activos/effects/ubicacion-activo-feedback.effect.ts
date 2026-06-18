import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { UbicacionActivoStore } from '../store/ubicacion-activo.store';

@Injectable()
export class UbicacionActivoFeedbackEffects {
  private readonly store        = inject(UbicacionActivoStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.toastService.success('Ubicación guardada correctamente');
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
        this.toastService.success('Ubicación actualizada correctamente');
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
        this.toastService.success('Ubicación eliminada correctamente');
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
