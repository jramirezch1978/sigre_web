import { Injectable, inject, effect, untracked } from '@angular/core';
import { CondicionPagoStore } from '../store/condicion-pago.store';
import { ToastService } from '../../../ui/services/toast.service';

@Injectable()
export class CondicionPagoFeedbackEffects {

  private readonly store = inject(CondicionPagoStore);
  private readonly toastService = inject(ToastService);

  private onGuardarExitoCallback?: () => void;
  private onActualizarExitoCallback?: () => void;
  private onEliminarExitoCallback?: () => void;

  constructor() {
    this.onGuardarSuccess();
    this.onActualizarSuccess();
    this.onEliminarSuccess();

    this.onGuardarError();
    this.onActualizarError();
    this.onEliminarError();
    this.onObtenerError();
  }

  registrarCallbacks(callbacks: {
    onGuardarExito?: () => void;
    onActualizarExito?: () => void;
    onEliminarExito?: () => void;
  }): void {
    this.onGuardarExitoCallback = callbacks.onGuardarExito;
    this.onActualizarExitoCallback = callbacks.onActualizarExito;
    this.onEliminarExitoCallback = callbacks.onEliminarExito;
  }

  private onGuardarSuccess() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        untracked(() => {
          this.toastService.success(result.message || '¡Condición de pago registrada correctamente!');
          this.onGuardarExitoCallback?.();
          this.store.resetResults();
        });
      }
    });
  }

  private onActualizarSuccess() {
    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        untracked(() => {
          this.toastService.success(result.message || '¡Condición de pago actualizada correctamente!');
          this.onActualizarExitoCallback?.();
          this.store.resetResults();
        });
      }
    });
  }

  private onEliminarSuccess() {
    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        untracked(() => {
          this.toastService.success(result.message || '¡Condición de pago eliminada correctamente!');
          this.onEliminarExitoCallback?.();
          this.store.resetResults();
        });
      }
    });
  }

  private onGuardarError() {
    effect(() => {
      const error = this.store.errorGuardar();
      if (error) {
        untracked(() => {
          this.toastService.danger(error);
          this.store.resetErrors();
        });
      }
    });
  }

  private onActualizarError() {
    effect(() => {
      const error = this.store.errorActualizar();
      if (error) {
        untracked(() => {
          this.toastService.danger(error);
          this.store.resetErrors();
        });
      }
    });
  }

  private onEliminarError() {
    effect(() => {
      const error = this.store.errorEliminar();
      if (error) {
        untracked(() => {
          this.toastService.danger(error);
          this.store.resetErrors();
        });
      }
    });
  }

  private onObtenerError() {
    effect(() => {
      const error = this.store.errorObtener();
      if (error) {
        untracked(() => {
          this.toastService.danger(error);
          this.store.resetErrors();
        });
      }
    });
  }
}
