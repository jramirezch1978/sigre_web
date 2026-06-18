import { Injectable, effect, inject, untracked } from '@angular/core';
import { ReporteFinancieroStore } from '../store/reporte-financiero.store';
import { ToastService } from '../../../ui/services/toast.service';
import { REPORTE_FINANCIERO_MENSAJES_FALLBACK } from '../constants/reporte-financiero.constants';

/**
 * ReporteFinancieroFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha errores del store del reporte financiero y muestra notificaciones toast.
 */
@Injectable()
export class ReporteFinancieroFeedbackEffects {

  private readonly store = inject(ReporteFinancieroStore);
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
            error || REPORTE_FINANCIERO_MENSAJES_FALLBACK.ERROR_CARGA
          );
          this.store.setErrorObtener(null);
        });
      }
    });
  }
}
