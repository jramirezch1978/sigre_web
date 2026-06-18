import { Injectable, inject, effect } from '@angular/core';
import { ReporteVentasStore } from '../store/reporte-ventas.store';
import { ToastService } from '../../../ui/services/toast.service';

/**
 * @summary Effects de feedback para el reporte de ventas.
 * @description
 * Reacciona al signal de error y muestra un toast de error.
 */
@Injectable()
export class ReporteVentasFeedbackEffects {

  private readonly store = inject(ReporteVentasStore);
  private readonly toast = inject(ToastService);

  constructor() {
    this.errorEffect();
  }

  private errorEffect() {
    effect(() => {
      const error = this.store.error();
      if (error) {
        this.toast.danger(error);
        this.store.setError(null);
      }
    });
  }
}
