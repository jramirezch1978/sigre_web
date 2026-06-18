import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { AprovisionamientoStore } from '../stores/aprovisionamiento.store';

/**
 * Effect: Feedback de Aprovisionamiento
 * Muestra toasts cuando hay éxito o error en las operaciones CRUD
 */
@Injectable()
export class AprovisionamientoFeedbackEffects {
  private readonly toastService = inject(ToastService);
  private readonly store = inject(AprovisionamientoStore);

  private previousLoadingGuardar = false;
  private previousLoadingActualizar = false;
  private previousLoadingEliminar = false;

  constructor() {
    // Effect: feedback al guardar
    effect(() => {
      const loading = this.store.loadingGuardar();
      const error = this.store.errorGuardar();

      if (this.previousLoadingGuardar && !loading) {
        if (error) {
          this.toastService.danger(error);
        } else {
          this.toastService.success('¡Plan de abastecimiento registrado exitosamente!');
        }
      }
      this.previousLoadingGuardar = loading;
    });

    // Effect: feedback al actualizar
    effect(() => {
      const loading = this.store.loadingActualizar();
      const error = this.store.errorActualizar();

      if (this.previousLoadingActualizar && !loading) {
        if (error) {
          this.toastService.danger(error);
        } else {
          this.toastService.success('¡Plan de abastecimiento actualizado exitosamente!');
        }
      }
      this.previousLoadingActualizar = loading;
    });

    // Effect: feedback al eliminar
    effect(() => {
      const loading = this.store.loadingEliminar();
      const error = this.store.errorEliminar();

      if (this.previousLoadingEliminar && !loading) {
        if (error) {
          this.toastService.danger(error);
        } else {
          this.toastService.success('¡Plan de abastecimiento eliminado exitosamente!');
        }
      }
      this.previousLoadingEliminar = loading;
    });

    // Effect: error al obtener
    effect(() => {
      const error = this.store.errorObtener();
      if (error) {
        this.toastService.danger(error);
      }
    });
  }
}
