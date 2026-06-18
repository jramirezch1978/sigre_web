import { Injectable, inject, effect, untracked } from '@angular/core';
import { ActivoFijoStore } from '../store/activo-fijo.store';
import { ToastService } from '../../../ui/services/toast.service';
import { ACTIVO_FIJO_MENSAJES_FALLBACK } from '../constants/activo-fijo.constants';

/**
 * Effects de feedback para operaciones de Activos Fijos.
 * Muestra toasts de éxito/error usando Angular Signals (effect).
 * No requiere suscripciones manuales.
 */
@Injectable()
export class ActivoFijoFeedbackEffects {

  private readonly store = inject(ActivoFijoStore);
  private readonly toast = inject(ToastService);

  private onGuardarExitoCallback?:    () => void;
  private onEliminarExitoCallback?:   () => void;
  private onActualizarExitoCallback?: () => void;

  constructor() {
    this.guardarEffect();
    this.eliminarEffect();
    this.actualizarEffect();
    this.obtenerEffect();
  }

  registrarCallbacks(callbacks: {
    onGuardarExito?:    () => void;
    onEliminarExito?:   () => void;
    onActualizarExito?: () => void;
  }): void {
    this.onGuardarExitoCallback    = callbacks.onGuardarExito;
    this.onEliminarExitoCallback   = callbacks.onEliminarExito;
    this.onActualizarExitoCallback = callbacks.onActualizarExito;
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────
  private manejarExito(mensaje: string, callback?: () => void, resetFn?: () => void): void {
    this.toast.success(mensaje);
    callback?.();
    resetFn?.();
  }

  private manejarError(mensaje: string, resetFn?: () => void): void {
    this.toast.danger(mensaje);
    resetFn?.();
  }

  // ─────────────────────────────────────────────
  // EFFECT: GUARDAR
  // ─────────────────────────────────────────────
  private guardarEffect(): void {
    effect(() => {
      const result = this.store.resultGuardar();
      if (!result) return;
      untracked(() => {
        if (result.success) {
          this.manejarExito(
            result.message || ACTIVO_FIJO_MENSAJES_FALLBACK.GUARDADO_DESCRIPCION,
            this.onGuardarExitoCallback,
            () => this.store.setResultGuardar(null)
          );
        } else {
          this.manejarError(
            result.message || ACTIVO_FIJO_MENSAJES_FALLBACK.ERROR_GUARDAR,
            () => this.store.setResultGuardar(null)
          );
        }
      });
    });
  }

  // ─────────────────────────────────────────────
  // EFFECT: ELIMINAR
  // ─────────────────────────────────────────────
  private eliminarEffect(): void {
    effect(() => {
      const result = this.store.resultEliminar();
      if (!result) return;
      untracked(() => {
        if (result.success) {
          this.manejarExito(
            result.message || ACTIVO_FIJO_MENSAJES_FALLBACK.ELIMINADO_DESCRIPCION,
            this.onEliminarExitoCallback,
            () => this.store.setResultEliminar(null)
          );
        } else {
          this.manejarError(
            result.message || ACTIVO_FIJO_MENSAJES_FALLBACK.ERROR_ELIMINAR,
            () => this.store.setResultEliminar(null)
          );
        }
      });
    });
  }

  // ─────────────────────────────────────────────
  // EFFECT: ACTUALIZAR
  // ─────────────────────────────────────────────
  private actualizarEffect(): void {
    effect(() => {
      const result = this.store.resultActualizar();
      if (!result) return;
      untracked(() => {
        if (result.success) {
          this.manejarExito(
            result.message || ACTIVO_FIJO_MENSAJES_FALLBACK.ACTUALIZADO_DESCRIPCION,
            this.onActualizarExitoCallback,
            () => this.store.setResultActualizar(null)
          );
        } else {
          this.manejarError(
            result.message || ACTIVO_FIJO_MENSAJES_FALLBACK.ERROR_ACTUALIZAR,
            () => this.store.setResultActualizar(null)
          );
        }
      });
    });
  }

  // ─────────────────────────────────────────────
  // EFFECT: ERROR AL OBTENER
  // ─────────────────────────────────────────────
  private obtenerEffect(): void {
    effect(() => {
      const error = this.store.errorObtener();
      if (!error) return;
      untracked(() => {
        this.manejarError(
          error || ACTIVO_FIJO_MENSAJES_FALLBACK.ERROR_CARGAR,
          () => this.store.setErrorObtener(null)
        );
      });
    });
  }
}
