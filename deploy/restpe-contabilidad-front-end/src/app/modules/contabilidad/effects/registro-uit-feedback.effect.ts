import { Injectable, effect, inject, untracked } from '@angular/core';
import { RegistroUitStore } from '../store/registro-uit.store';
import { ToastService } from '../../../ui/services/toast.service';
import { REGISTRO_UIT_MENSAJES_FALLBACK } from '../constants/registro-uit.constants';
import { obtenerMensajeConFallback } from '../../../core/utils/api-response.util';

export interface RegistroUitCallbacks {
  onGuardarExito?: () => void;
  onActualizarExito?: () => void;
}

/**
 * RegistroUitFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha los resultados del store y muestra notificaciones toast.
 * Llama callbacks opcionales en caso de éxito para coordinar el componente.
 */
@Injectable()
export class RegistroUitFeedbackEffects {

  private readonly store = inject(RegistroUitStore);
  private readonly toast = inject(ToastService);
  private callbacks: RegistroUitCallbacks = {};

  constructor() {
    this.guardarEffect();
    this.actualizarEffect();
    this.obtenerEffect();
  }

  registrarCallbacks(callbacks: RegistroUitCallbacks): void {
    this.callbacks = callbacks;
  }

  // ── Utilidades ───────────────────────────────────────────────────────────

  private manejarExito(mensaje: string, callback?: () => void): void {
    this.toast.success(mensaje);
    callback?.();
  }

  private manejarError(mensaje: string): void {
    this.toast.danger(mensaje);
  }

  // ── Efectos ──────────────────────────────────────────────────────────────

  private guardarEffect(): void {
    effect(() => {
      const resultado = this.store.resultGuardar();
      const error     = this.store.errorGuardar();

      if (resultado) {
        untracked(() => {
          const mensaje = obtenerMensajeConFallback(
            resultado,
            REGISTRO_UIT_MENSAJES_FALLBACK.GUARDADO_DESCRIPCION
          );
          this.manejarExito(mensaje, this.callbacks.onGuardarExito);
          this.store.setGuardarResultado(null);
        });
      }

      if (error) {
        untracked(() => {
          this.manejarError(error);
          this.store.setErrorGuardar(null);
        });
      }
    });
  }

  private actualizarEffect(): void {
    effect(() => {
      const resultado = this.store.resultActualizar();
      const error     = this.store.errorActualizar();

      if (resultado) {
        untracked(() => {
          const mensaje = obtenerMensajeConFallback(
            resultado,
            REGISTRO_UIT_MENSAJES_FALLBACK.ACTUALIZADO_DESCRIPCION
          );
          this.manejarExito(mensaje, this.callbacks.onActualizarExito);
          this.store.setActualizarResultado(null);
        });
      }

      if (error) {
        untracked(() => {
          this.manejarError(error);
          this.store.setErrorActualizar(null);
        });
      }
    });
  }

  private obtenerEffect(): void {
    effect(() => {
      const error = this.store.errorObtener();

      if (error) {
        untracked(() => {
          this.manejarError(error);
          this.store.setErrorObtener(null);
        });
      }
    });
  }
}
