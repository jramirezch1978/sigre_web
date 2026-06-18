import { Injectable, effect, inject, untracked } from '@angular/core';
import { DetraccionStore } from '../store/detraccion.store';
import { ToastService } from '../../../ui/services/toast.service';
import { DETRACCION_MENSAJES_FALLBACK } from '../constants/detraccion.constants';
import { obtenerMensajeConFallback } from '../../../core/utils/api-response.util';

@Injectable()
export class DetraccionFeedbackEffects {

  private readonly store = inject(DetraccionStore);
  private readonly toast = inject(ToastService);

  private onGuardarExitoCallback?: () => void;
  private onEliminarExitoCallback?: () => void;
  private onActualizarExitoCallback?: () => void;

  constructor() {
    this.guardarEffect();
    this.eliminarEffect();
    this.actualizarEffect();
    this.obtenerEffect();
  }

  registrarCallbacks(callbacks: {
    onGuardarExito?: () => void;
    onEliminarExito?: () => void;
    onActualizarExito?: () => void;
  }): void {
    this.onGuardarExitoCallback = callbacks.onGuardarExito;
    this.onEliminarExitoCallback = callbacks.onEliminarExito;
    this.onActualizarExitoCallback = callbacks.onActualizarExito;
  }

  private manejarExito(mensaje: string, callback?: () => void, resetFn?: () => void): void {
    this.toast.success(mensaje);
    callback?.();
    resetFn?.();
  }

  private manejarError(mensaje: string, resetFn?: () => void): void {
    this.toast.danger(mensaje);
    resetFn?.();
  }

  private guardarEffect(): void {
    effect(() => {
      const resultado = this.store.resultGuardar();
      const error = this.store.errorGuardar();

      if (resultado) {
        untracked(() => {
          const mensaje = obtenerMensajeConFallback(resultado, DETRACCION_MENSAJES_FALLBACK.GUARDADO_DESCRIPCION);
          this.manejarExito(mensaje, this.onGuardarExitoCallback, () => this.store.setGuardarResultado(null));
        });
      }

      if (error) {
        untracked(() => {
          this.manejarError(error, () => this.store.setErrorGuardar(null));
        });
      }
    });
  }

  private eliminarEffect(): void {
    effect(() => {
      const resultado = this.store.resultEliminar();
      const error = this.store.errorEliminar();

      if (resultado) {
        untracked(() => {
          const mensaje = obtenerMensajeConFallback(resultado, DETRACCION_MENSAJES_FALLBACK.ELIMINADO_DESCRIPCION);
          this.manejarExito(mensaje, this.onEliminarExitoCallback, () => this.store.setEliminarResultado(null));
        });
      }

      if (error) {
        untracked(() => {
          this.manejarError(error, () => this.store.setErrorEliminar(null));
        });
      }
    });
  }

  private actualizarEffect(): void {
    effect(() => {
      const resultado = this.store.resultActualizar();
      const error = this.store.errorActualizar();

      if (resultado) {
        untracked(() => {
          const mensaje = obtenerMensajeConFallback(resultado, DETRACCION_MENSAJES_FALLBACK.ACTUALIZADO_DESCRIPCION);
          this.manejarExito(mensaje, this.onActualizarExitoCallback, () => this.store.setActualizarResultado(null));
        });
      }

      if (error) {
        untracked(() => {
          this.manejarError(error, () => this.store.setErrorActualizar(null));
        });
      }
    });
  }

  private obtenerEffect(): void {
    effect(() => {
      const error = this.store.errorObtener();

      if (error) {
        untracked(() => {
          this.manejarError(error, () => this.store.setErrorObtener(null));
        });
      }
    });
  }
}
