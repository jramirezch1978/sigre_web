import { Injectable, effect, inject, untracked } from '@angular/core';
import { SeleccionarCuentaContableStore } from '../store/seleccionar-cuenta-contable.store';
import { ToastService } from '../../../ui/services/toast.service';
import { SELECCIONAR_CUENTA_CONTABLE_MENSAJES_FALLBACK } from '../constants/seleccionar-cuenta-contable.constants';

/**
 * SeleccionarCuentaContableFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha errores del store y muestra notificaciones toast.
 */
@Injectable()
export class SeleccionarCuentaContableFeedbackEffects {

  private readonly store = inject(SeleccionarCuentaContableStore);
  private readonly toast = inject(ToastService);

  constructor() {
    this.obtenerEffect();
  }

  // ── Efectos ──────────────────────────────────────────────────────────────

  private obtenerEffect(): void {
    effect(() => {
      const error = this.store.errorObtener();

      if (error) {
        untracked(() => {
          this.toast.danger(
            error || SELECCIONAR_CUENTA_CONTABLE_MENSAJES_FALLBACK.ERROR_CARGA
          );
          this.store.setErrorObtener(null);
        });
      }
    });
  }
}
