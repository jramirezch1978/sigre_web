import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ClasifActivoStore } from '../store/clasif-activo.store';

/**
 * Effects de feedback para Clasificación de Activos.
 * Muestra toasts de éxito/error tras cada operación CRUD.
 * Usa Angular Signals (effect) — sin suscripciones manuales.
 */
@Injectable()
export class ClasifActivoFeedbackEffects {

  private readonly store = inject(ClasifActivoStore);
  private readonly toast = inject(ToastService);

  private onGuardarOk?: () => void;
  private onActualizarOk?: () => void;
  private onEliminarOk?: () => void;

  constructor() {
    effect(() => {
      if (this.store.resultGuardar()) {
        this.toast.success('¡Clasificación creada exitosamente!');
        this.onGuardarOk?.();
      }
    });

    effect(() => {
      if (this.store.resultActualizar()) {
        this.toast.success('¡Se guardaron cambios exitosamente!');
        this.onActualizarOk?.();
      }
    });

    effect(() => {
      if (this.store.resultEliminar()) {
        this.toast.success('¡Clasificación eliminada exitosamente!');
        this.onEliminarOk?.();
      }
    });

    effect(() => {
      const err = this.store.errorGuardar();
      if (err) this.toast.danger(err);
    });

    effect(() => {
      const err = this.store.errorActualizar();
      if (err) this.toast.danger(err);
    });

    effect(() => {
      const err = this.store.errorEliminar();
      if (err) this.toast.danger(err);
    });

    effect(() => {
      const err = this.store.errorObtener();
      if (err) this.toast.danger(err);
    });
  }

  /** Registra callbacks opcionales post-acción */
  registrarCallbacks(callbacks: {
    onGuardarOk?: () => void;
    onActualizarOk?: () => void;
    onEliminarOk?: () => void;
  }): void {
    this.onGuardarOk    = callbacks.onGuardarOk;
    this.onActualizarOk = callbacks.onActualizarOk;
    this.onEliminarOk   = callbacks.onEliminarOk;
  }
}
