import { Injectable, effect, inject, untracked } from '@angular/core';
import { MaestroContableStore } from '../store/maestro-contable.store';
import { ToastService } from '../../../ui/services/toast.service';
import { MAESTRO_CONTABLE_MENSAJES_FALLBACK } from '../constants/maestro-contable.constants';

/**
 * MaestroContableFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha errores del store y muestra notificaciones toast.
 */
@Injectable()
export class MaestroContableFeedbackEffects {

  private readonly store = inject(MaestroContableStore);
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
            error || MAESTRO_CONTABLE_MENSAJES_FALLBACK.ERROR_CARGA
          );
          this.store.setErrorObtener(null);
        });
      }
    });
  }
}
