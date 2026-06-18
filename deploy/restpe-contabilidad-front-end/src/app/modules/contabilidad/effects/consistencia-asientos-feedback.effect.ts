import { Injectable, effect, inject, untracked } from '@angular/core';
import { ConsistenciaAsientosStore } from '../store/consistencia-asientos.store';
import { ToastService } from '../../../ui/services/toast.service';
import { CONSISTENCIA_ASIENTOS_MENSAJES_FALLBACK } from '../constants/consistencia-asientos.constants';

/**
 * ConsistenciaAsientosFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha errores del store y muestra notificaciones toast.
 */
@Injectable()
export class ConsistenciaAsientosFeedbackEffects {

  private readonly store = inject(ConsistenciaAsientosStore);
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
            error || CONSISTENCIA_ASIENTOS_MENSAJES_FALLBACK.ERROR_CARGA
          );
          this.store.setErrorObtener(null);
        });
      }
    });
  }
}
