import { Injectable, effect, inject, untracked } from '@angular/core';
import { TablasContabilidadStore } from '../store/tablas-contabilidad.store';
import { ToastService } from '../../../ui/services/toast.service';
import { TABLAS_CONTABILIDAD_MENSAJES_FALLBACK } from '../constants/tablas-contabilidad.constants';

/**
 * TablasContabilidadFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha errores del store y muestra notificaciones toast.
 */
@Injectable()
export class TablasContabilidadFeedbackEffects {

  private readonly store = inject(TablasContabilidadStore);
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
            error || TABLAS_CONTABILIDAD_MENSAJES_FALLBACK.ERROR_CARGA
          );
          this.store.setErrorObtener(null);
        });
      }
    });
  }
}
