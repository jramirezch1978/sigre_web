import { Injectable, effect, inject, untracked } from '@angular/core';
import { GestionAsientosAutomaticoStore } from '../store/gestion-asientos-automatico.store';
import { ToastService } from '../../../ui/services/toast.service';
import { GESTION_ASIENTOS_AUTOMATICOS_MENSAJES_FALLBACK } from '../constants/gestion-asientos-automaticos.constants';

/**
 * GestionAsientosAutomaticosFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha errores del store y muestra notificaciones toast.
 */
@Injectable()
export class GestionAsientosAutomaticosFeedbackEffects {

  private readonly store = inject(GestionAsientosAutomaticoStore);
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
            error || GESTION_ASIENTOS_AUTOMATICOS_MENSAJES_FALLBACK.ERROR_CARGA
          );
          this.store.setErrorObtener(null);
        });
      }
    });
  }
}
