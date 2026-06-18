import { Injectable, effect, inject, untracked } from '@angular/core';
import { ReporteValidacionStore } from '../store/reporte-validacion.store';
import { ToastService } from '../../../ui/services/toast.service';
import { REPORTE_VALIDACION_MENSAJES_FALLBACK } from '../constants/reporte-validacion.constants';

/**
 * ReporteValidacionFeedbackEffects — Efectos de retroalimentación de UI.
 * Escucha errores del store y muestra notificaciones toast.
 */
@Injectable()
export class ReporteValidacionFeedbackEffects {

  private readonly store = inject(ReporteValidacionStore);
  private readonly toast = inject(ToastService);

  constructor() {
    this.errorConsistenciaEffect();
    this.errorConsistenciaPreEffect();
    this.errorAsientosDesEffect();
  }

  // ── Efectos ──────────────────────────────────────────────────────────────

  private errorConsistenciaEffect(): void {
    effect(() => {
      const error = this.store.errorConsistencia();
      if (error) {
        untracked(() => {
          this.toast.danger(error || REPORTE_VALIDACION_MENSAJES_FALLBACK.ERROR_CARGA);
          this.store.setErrorConsistencia(null);
        });
      }
    });
  }

  private errorConsistenciaPreEffect(): void {
    effect(() => {
      const error = this.store.errorConsistenciaPre();
      if (error) {
        untracked(() => {
          this.toast.danger(error || REPORTE_VALIDACION_MENSAJES_FALLBACK.ERROR_CARGA);
          this.store.setErrorConsistenciaPre(null);
        });
      }
    });
  }

  private errorAsientosDesEffect(): void {
    effect(() => {
      const error = this.store.errorAsientosDes();
      if (error) {
        untracked(() => {
          this.toast.danger(error || REPORTE_VALIDACION_MENSAJES_FALLBACK.ERROR_CARGA);
          this.store.setErrorAsientosDes(null);
        });
      }
    });
  }
}
