import { Injectable, effect, inject, untracked } from '@angular/core';
import { AnalisisCuentaContableStore } from '../store/analisis-cuenta-contable.store';
import { ToastService } from '../../../ui/services/toast.service';
import { ANALISIS_CUENTA_CONTABLE_MENSAJES_FALLBACK } from '../constants/analisis-cuenta-contable.constants';

/**
 * AnalisisCuentaContableFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha errores del store y muestra notificaciones toast.
 */
@Injectable()
export class AnalisisCuentaContableFeedbackEffects {

  private readonly store = inject(AnalisisCuentaContableStore);
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
            error || ANALISIS_CUENTA_CONTABLE_MENSAJES_FALLBACK.ERROR_CARGA
          );
          this.store.setErrorObtener(null);
        });
      }
    });
  }
}
