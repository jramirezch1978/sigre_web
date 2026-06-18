import { Injectable, inject, effect } from '@angular/core';
import { FacturacionRegaliasStore } from '../store/facturacion-regalias.store';
import { ToastService } from '../../../ui/services/toast.service';

/**
 * @summary Effects de feedback para operaciones de facturación de regalías.
 * @description
 * Maneja los efectos secundarios de las operaciones de facturación:
 * - Muestra toasts de éxito/error tras guardar o anular.
 * - Limpia el estado del store para evitar loops de effects.
 *
 * Usa Angular Signals con `effect` para reactividad sin suscripciones manuales.
 */
@Injectable()
export class FacturacionRegaliasFeedbackEffects {

  private readonly store = inject(FacturacionRegaliasStore);
  private readonly toast = inject(ToastService);

  private onGuardarExitoCallback?: () => void;
  private onAnularExitoCallback?: () => void;

  constructor() {
    this.guardarEffect();
    this.anularEffect();
    this.obtenerEffect();
  }

  registrarCallbacks(callbacks: {
    onGuardarExito?: () => void;
    onAnularExito?: () => void;
  }): void {
    this.onGuardarExitoCallback = callbacks.onGuardarExito;
    this.onAnularExitoCallback = callbacks.onAnularExito;
  }

  private guardarEffect() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result) {
        if (result.success) {
          this.toast.success(result.message || '¡Facturación de regalía registrada con éxito!');
          this.onGuardarExitoCallback?.();
        } else {
          this.toast.danger(result.message || 'Error al registrar la facturación de regalía');
        }
        this.store.setGuardarResultado(null);
      }
    });
  }

  private anularEffect() {
    effect(() => {
      const result = this.store.resultAnular();
      if (result) {
        if (result.success) {
          this.toast.success(result.message || '¡La acción se realizó con éxito!');
          this.onAnularExitoCallback?.();
        } else {
          this.toast.danger(result.message || 'Error al anular la facturación de regalía');
        }
        this.store.setAnularResultado(null);
      }
    });
  }

  private obtenerEffect() {
    effect(() => {
      const error = this.store.errorObtener();
      if (error) {
        this.toast.danger(error);
        this.store.setErrorObtener(null);
      }
    });
  }
}
