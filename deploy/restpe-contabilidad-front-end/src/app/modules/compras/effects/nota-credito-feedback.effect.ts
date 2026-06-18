import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { NotaCreditoStore } from '../stores/nota-credito.store';

/**
 * Effects de feedback (toasts) para Notas de Crédito/Débito
 * Se activan automáticamente al detectar transiciones en el store
 */
@Injectable()
export class NotaCreditoFeedbackEffects {
  private readonly store = inject(NotaCreditoStore);
  private readonly toastService = inject(ToastService);

  constructor() {
    let previousLoadingGuardar = false;
    let previousLoadingActualizar = false;
    let previousLoadingEliminar = false;

    // Effect: Toast al guardar
    effect(() => {
      const isLoading = this.store.loadingGuardar();
      const error = this.store.errorGuardar();

      if (previousLoadingGuardar && !isLoading) {
        if (error) {
          this.toastService.danger('Error al guardar la nota: ' + error);
        } else {
          const nota = this.store.notaActual();
          this.toastService.success(`¡${nota?.nota_credito_tipo ?? 'Nota'} creada exitosamente!`);
        }
      }
      previousLoadingGuardar = isLoading;
    });

    // Effect: Toast al actualizar
    effect(() => {
      const isLoading = this.store.loadingActualizar();
      const error = this.store.errorActualizar();

      if (previousLoadingActualizar && !isLoading) {
        if (error) {
          this.toastService.danger('Error al actualizar la nota: ' + error);
        } else {
          const nota = this.store.notaActual();
          this.toastService.success(`¡${nota?.nota_credito_tipo ?? 'Nota'} actualizada exitosamente!`);
        }
      }
      previousLoadingActualizar = isLoading;
    });

    // Effect: Toast al eliminar
    effect(() => {
      const isLoading = this.store.loadingEliminar();
      const error = this.store.errorEliminar();

      if (previousLoadingEliminar && !isLoading) {
        if (error) {
          this.toastService.danger('Error al eliminar la nota: ' + error);
        } else {
          const nota = this.store.notaActual();
          this.toastService.success(`¡${nota?.nota_credito_tipo ?? 'Nota'} eliminada exitosamente!`);
        }
      }
      previousLoadingEliminar = isLoading;
    });
  }
}
