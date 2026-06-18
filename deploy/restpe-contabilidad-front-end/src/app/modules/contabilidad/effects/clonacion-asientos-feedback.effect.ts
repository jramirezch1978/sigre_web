import { Injectable, effect, inject, untracked } from '@angular/core';
import { ClonacionAsientosStore } from '../store/clonacion-asientos.store';
import { ToastService } from '../../../ui/services/toast.service';
import { CLONACION_ASIENTOS_MENSAJES_FALLBACK } from '../constants/clonacion-asientos.constants';

/**
 * ClonacionAsientosFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha errores del store y muestra notificaciones toast.
 */
@Injectable()
export class ClonacionAsientosFeedbackEffects {

  private readonly store = inject(ClonacionAsientosStore);
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
            error || CLONACION_ASIENTOS_MENSAJES_FALLBACK.ERROR_CARGA
          );
          this.store.setErrorObtener(null);
        });
      }
    });
  }
}
