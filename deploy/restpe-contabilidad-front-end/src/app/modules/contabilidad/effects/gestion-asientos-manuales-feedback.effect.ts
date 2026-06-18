import { Injectable, effect, inject, untracked } from '@angular/core';
import { GestionAsientosManualesStore } from '../store/gestion-asientos-manuales.store';
import { ToastService } from '../../../ui/services/toast.service';
import { GESTION_ASIENTOS_MANUALES_MENSAJES_FALLBACK } from '../constants/gestion-asientos-manuales.constants';
import { obtenerMensajeConFallback } from '../../../core/utils/api-response.util';

/**
 * GestionAsientosManualesFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha resultados y errores del store y muestra notificaciones toast.
 */
@Injectable()
export class GestionAsientosManualesFeedbackEffects {

  private readonly store = inject(GestionAsientosManualesStore);
  private readonly toast = inject(ToastService);

  private onGuardarExitoCallback?: () => void;
  private onActualizarExitoCallback?: () => void;
  private onAnularExitoCallback?: () => void;

  constructor() {
    this.guardarEffect();
    this.actualizarEffect();
    this.anularEffect();
    this.obtenerEffect();
  }

  registrarCallbacks(callbacks: {
    onGuardarExito?: () => void;
    onActualizarExito?: () => void;
    onAnularExito?: () => void;
  }): void {
    this.onGuardarExitoCallback   = callbacks.onGuardarExito;
    this.onActualizarExitoCallback = callbacks.onActualizarExito;
    this.onAnularExitoCallback    = callbacks.onAnularExito;
  }

  // ── Efectos ──────────────────────────────────────────────────────────────

  private guardarEffect(): void {
    effect(() => {
      const resultado = this.store.resultGuardar();
      const error     = this.store.errorGuardar();

      if (resultado) {
        untracked(() => {
          const mensaje = obtenerMensajeConFallback(resultado, GESTION_ASIENTOS_MANUALES_MENSAJES_FALLBACK.GUARDADO_DESCRIPCION);
          this.toast.success(mensaje);
          this.onGuardarExitoCallback?.();
          this.store.setGuardarResultado(null);
        });
      }

      if (error) {
        untracked(() => {
          this.toast.danger(error);
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
          const mensaje = obtenerMensajeConFallback(resultado, GESTION_ASIENTOS_MANUALES_MENSAJES_FALLBACK.ACTUALIZADO_DESCRIPCION);
          this.toast.success(mensaje);
          this.onActualizarExitoCallback?.();
          this.store.setActualizarResultado(null);
        });
      }

      if (error) {
        untracked(() => {
          this.toast.danger(error);
          this.store.setErrorActualizar(null);
        });
      }
    });
  }

  private anularEffect(): void {
    effect(() => {
      const resultado = this.store.resultAnular();
      const error     = this.store.errorAnular();

      if (resultado) {
        untracked(() => {
          const mensaje = obtenerMensajeConFallback(resultado, GESTION_ASIENTOS_MANUALES_MENSAJES_FALLBACK.ANULADO_DESCRIPCION);
          this.toast.success(mensaje);
          this.onAnularExitoCallback?.();
          this.store.setAnularResultado(null);
        });
      }

      if (error) {
        untracked(() => {
          this.toast.danger(error);
          this.store.setErrorAnular(null);
        });
      }
    });
  }

  private obtenerEffect(): void {
    effect(() => {
      const error = this.store.errorObtener();

      if (error) {
        untracked(() => {
          this.toast.danger(error || GESTION_ASIENTOS_MANUALES_MENSAJES_FALLBACK.ERROR_CARGA);
          this.store.setErrorObtener(null);
        });
      }
    });
  }
}

