import { Injectable, effect, inject, untracked } from '@angular/core';
import { ConsultaCentroCostosStore } from '../store/consulta-centro-costos.store';
import { ToastService } from '../../../ui/services/toast.service';
import { CONSULTA_CENTRO_COSTOS_MENSAJES_FALLBACK } from '../constants/consulta-centro-costos.constants';

/**
 * ConsultaCentroCostosFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha errores del store y muestra notificaciones toast.
 */
@Injectable()
export class ConsultaCentroCostosFeedbackEffects {

  private readonly store = inject(ConsultaCentroCostosStore);
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
            error || CONSULTA_CENTRO_COSTOS_MENSAJES_FALLBACK.ERROR_CARGA
          );
          this.store.setErrorObtener(null);
        });
      }
    });
  }
}
