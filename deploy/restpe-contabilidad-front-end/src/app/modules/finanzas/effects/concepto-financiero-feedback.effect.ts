import { Injectable, inject, effect } from '@angular/core';
import { ConceptoFinancieroStore } from '../store/concepto-financiero.store';
import { ToastService } from '../../../ui/services/toast.service';

/**
 * @summary Effects de feedback para concepto financiero.
 * @description
 * Muestra toasts según el resultado de guardar/actualizar y en caso de errores.
 */
@Injectable()
export class ConceptoFinancieroFeedbackEffects {

  private readonly store = inject(ConceptoFinancieroStore);
  private readonly toast = inject(ToastService);

  constructor() {
    this.guardarExitoEffect();
    this.actualizarExitoEffect();
    this.eliminarExitoEffect();
    this.errorObtenerEffect();
    this.errorGuardarEffect();
    this.errorActualizarEffect();
    this.errorEliminarEffect();
  }

 private guardarExitoEffect() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result) {
        this.toast.success('¡Concepto registrado exitosamente!');
        this.store.setResultGuardar(result);
      }
    });
  }

  private actualizarExitoEffect() {
    effect(() => {
      const result = this.store.resultActualizar();
      if (result) {
        this.toast.success('¡Concepto actualizado exitosamente!');
        this.store.setResultActualizar(result);
      }
    });
  }

  private eliminarExitoEffect() {
    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.toast.success('¡Concepto eliminado exitosamente!');
        this.store.setResultEliminar(null);
      }
    });
  }

  private errorObtenerEffect() {
    effect(() => {
      const error = this.store.errorObtener();
      if (error) {
        this.toast.danger(error);
        this.store.setErrorObtener(null);
      }
    });
  }

  private errorEliminarEffect() {
    effect(() => {
      const error = this.store.errorEliminar();
      if (error) {
        this.toast.danger(error);
        this.store.setErrorEliminar(null);
      }
    });
  }

  private errorGuardarEffect() {
    effect(() => {
      const error = this.store.errorGuardar();
      if (error) {
        this.toast.danger(error);
        this.store.setErrorGuardar(null);
      }
    });
  }

  private errorActualizarEffect() {
    effect(() => {
      const error = this.store.errorActualizar();
      if (error) {
        this.toast.danger(error);
        this.store.setErrorActualizar(null);
      }
    });
  }
}
