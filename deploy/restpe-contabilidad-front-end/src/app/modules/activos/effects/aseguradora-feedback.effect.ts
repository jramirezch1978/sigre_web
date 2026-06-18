import { Injectable, inject, effect, untracked } from '@angular/core';
import { AseguradoraStore } from '../store/aseguradora.store';
import { ToastService } from '../../../ui/services/toast.service';

const MENSAJES = {
  GUARDADO:    'La aseguradora se guardó correctamente',
  ELIMINADO:   'La aseguradora se eliminó correctamente',
  ACTUALIZADO: 'La aseguradora se actualizó correctamente',
  ERR_GUARDAR:    'Error al guardar la aseguradora',
  ERR_ELIMINAR:   'Error al eliminar la aseguradora',
  ERR_ACTUALIZAR: 'Error al actualizar la aseguradora',
  ERR_CARGAR:     'Error al cargar las aseguradoras',
} as const;

/**
 * Effects de feedback para operaciones de Aseguradoras.
 * Muestra toasts de éxito/error usando Angular Signals (effect).
 */
@Injectable()
export class AseguradoraFeedbackEffects {

  private readonly store = inject(AseguradoraStore);
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
      const result = this.store.resultGuardar();
      if (!result) return;
      untracked(() => {
        if (result.success) {
          this.manejarExito(
            result.message || MENSAJES.GUARDADO,
            this.onGuardarExitoCallback,
            () => this.store.setResultGuardar(null)
          );
        } else {
          this.manejarError(
            result.message || MENSAJES.ERR_GUARDAR,
            () => this.store.setResultGuardar(null)
          );
        }
      });
    });
  }

  private eliminarEffect(): void {
    effect(() => {
      const result = this.store.resultEliminar();
      if (!result) return;
      untracked(() => {
        if (result.success) {
          this.manejarExito(
            result.message || MENSAJES.ELIMINADO,
            this.onEliminarExitoCallback,
            () => this.store.setResultEliminar(null)
          );
        } else {
          this.manejarError(
            result.message || MENSAJES.ERR_ELIMINAR,
            () => this.store.setResultEliminar(null)
          );
        }
      });
    });
  }

  private actualizarEffect(): void {
    effect(() => {
      const result = this.store.resultActualizar();
      if (!result) return;
      untracked(() => {
        if (result.success) {
          this.manejarExito(
            result.message || MENSAJES.ACTUALIZADO,
            this.onActualizarExitoCallback,
            () => this.store.setResultActualizar(null)
          );
        } else {
          this.manejarError(
            result.message || MENSAJES.ERR_ACTUALIZAR,
            () => this.store.setResultActualizar(null)
          );
        }
      });
    });
  }

  private obtenerEffect(): void {
    effect(() => {
      const error = this.store.errorObtener();
      if (!error) return;
      untracked(() => {
        this.manejarError(
          error || MENSAJES.ERR_CARGAR,
          () => this.store.setErrorObtener(null)
        );
      });
    });
  }
}
