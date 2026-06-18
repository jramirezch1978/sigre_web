import { Injectable, effect, inject, untracked } from '@angular/core';
import { TipoDeCambioStore } from '../store/tipo-de-cambio.store';
import { ToastService } from '../../../ui/services/toast.service';
import { TIPO_DE_CAMBIO_MENSAJES_FALLBACK } from '../constants/tipo-de-cambio.constants';
import { obtenerMensajeConFallback } from '../../../core/utils/api-response.util';

export interface TipoDeCambioCallbacks {
  onGuardarExito?: () => void;
  onActualizarExito?: () => void;
  onEliminarExito?: () => void;
}

@Injectable()
export class TipoDeCambioFeedbackEffects {

  private readonly store = inject(TipoDeCambioStore);
  private readonly toast = inject(ToastService);
  private callbacks: TipoDeCambioCallbacks = {};

  constructor() {
    this.guardarEffect();
    this.actualizarEffect();
    this.eliminarEffect();
    this.obtenerEffect();
  }

  registrarCallbacks(callbacks: TipoDeCambioCallbacks): void {
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
      const error    = this.store.errorGuardar();

      if (resultado) {
        untracked(() => {
          const mensaje = obtenerMensajeConFallback(
            resultado,
            TIPO_DE_CAMBIO_MENSAJES_FALLBACK.GUARDADO_DESCRIPCION
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
      const error    = this.store.errorActualizar();

      if (resultado) {
        untracked(() => {
          const mensaje = obtenerMensajeConFallback(
            resultado,
            TIPO_DE_CAMBIO_MENSAJES_FALLBACK.ACTUALIZADO_DESCRIPCION
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

  private eliminarEffect(): void {
    effect(() => {
      const resultado = this.store.resultEliminar();
      const error    = this.store.errorEliminar();

      if (resultado) {
        untracked(() => {
          const mensaje = obtenerMensajeConFallback(
            resultado,
            TIPO_DE_CAMBIO_MENSAJES_FALLBACK.ELIMINADO_DESCRIPCION
          );
          this.manejarExito(mensaje, this.callbacks.onEliminarExito);
          this.store.setEliminarResultado(null);
        });
      }

      if (error) {
        untracked(() => {
          this.manejarError(error);
          this.store.setErrorEliminar(null);
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

