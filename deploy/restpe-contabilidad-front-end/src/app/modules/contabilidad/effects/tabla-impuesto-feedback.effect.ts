import { Injectable, effect, inject, untracked } from '@angular/core';
import { TablaImpuestoStore } from '../store/tabla-impuesto.store';
import { ToastService } from '../../../ui/services/toast.service';
import { TABLA_IMPUESTO_MENSAJES_FALLBACK } from '../constants/tabla-impuesto.constants';
import { obtenerMensajeConFallback } from '../../../core/utils/api-response.util';

export interface TablaImpuestoCallbacks {
  onGuardarExito?: () => void;
  onActualizarExito?: () => void;
}

@Injectable()
export class TablaImpuestoFeedbackEffects {

  private readonly store = inject(TablaImpuestoStore);
  private readonly toast = inject(ToastService);
  private callbacks: TablaImpuestoCallbacks = {};

  constructor() {
    this.guardarEffect();
    this.actualizarEffect();
    this.obtenerEffect();
  }

  registrarCallbacks(callbacks: TablaImpuestoCallbacks): void {
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
            TABLA_IMPUESTO_MENSAJES_FALLBACK.GUARDADO_DESCRIPCION
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
            TABLA_IMPUESTO_MENSAJES_FALLBACK.ACTUALIZADO_DESCRIPCION
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
