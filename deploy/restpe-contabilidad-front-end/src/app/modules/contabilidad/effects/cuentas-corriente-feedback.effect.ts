import { Injectable, effect, inject, untracked } from '@angular/core';
import { CuentasCorrienteStore } from '../store/cuentas-corriente.store';
import { ToastService } from '../../../ui/services/toast.service';
import { CUENTAS_CORRIENTE_MENSAJES_FALLBACK } from '../constants/cuentas-corriente.constants';

/**
 * CuentasCorrienteFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha errores del store y muestra notificaciones toast.
 */
@Injectable()
export class CuentasCorrienteFeedbackEffects {

  private readonly store = inject(CuentasCorrienteStore);
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
            error || CUENTAS_CORRIENTE_MENSAJES_FALLBACK.ERROR_CARGA
          );
          this.store.setErrorObtener(null);
        });
      }
    });
  }
}
