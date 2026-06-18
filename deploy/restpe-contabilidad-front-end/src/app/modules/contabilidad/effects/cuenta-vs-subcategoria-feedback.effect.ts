import { Injectable, effect, inject, untracked } from '@angular/core';
import { CuentaVsSubcategoriaStore } from '../store/cuenta-vs-subcategoria.store';
import { ToastService } from '../../../ui/services/toast.service';
import { CUENTA_VS_SUBCATEGORIA_MENSAJES_FALLBACK } from '../constants/cuenta-vs-subcategoria.constants';
import { obtenerMensajeConFallback } from '../../../core/utils/api-response.util';

@Injectable()
export class CuentaVsSubcategoriaFeedbackEffects {

  private readonly store = inject(CuentaVsSubcategoriaStore);
  private readonly toast = inject(ToastService);

  private onActualizarExitoCallback?: () => void;

  constructor() {
    this.actualizarEffect();
    this.obtenerEffect();
  }

  registrarCallbacks(callbacks: {
    onActualizarExito?: () => void;
  }): void {
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

  private actualizarEffect(): void {
    effect(() => {
      const resultado = this.store.resultActualizar();
      const error = this.store.errorActualizar();

      if (resultado) {
        untracked(() => {
          const mensaje = obtenerMensajeConFallback(resultado, CUENTA_VS_SUBCATEGORIA_MENSAJES_FALLBACK.ACTUALIZADO_DESCRIPCION);
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
