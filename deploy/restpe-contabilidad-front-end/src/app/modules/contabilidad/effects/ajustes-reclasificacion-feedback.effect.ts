import { Injectable, effect, inject, untracked } from '@angular/core';
import { AjustesReclasificacionStore } from '../store/ajustes-reclasificacion.store';
import { ToastService } from '../../../ui/services/toast.service';
import { AJUSTES_RECLASIFICACION_MENSAJES_FALLBACK } from '../constants/ajustes-reclasificacion.constants';

/**
 * AjustesReclasificacionFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha errores del store y muestra notificaciones toast.
 */
@Injectable()
export class AjustesReclasificacionFeedbackEffects {

  private readonly store = inject(AjustesReclasificacionStore);
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
            error || AJUSTES_RECLASIFICACION_MENSAJES_FALLBACK.ERROR_CARGA
          );
          this.store.setErrorObtener(null);
        });
      }
    });
  }
}
