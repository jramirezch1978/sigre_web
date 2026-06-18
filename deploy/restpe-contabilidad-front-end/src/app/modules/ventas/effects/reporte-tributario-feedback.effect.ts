import { Injectable, inject, effect } from '@angular/core';
import { ReporteTributarioStore } from '../store/reporte-tributario.store';
import { ToastService } from '../../../ui/services/toast.service';

/**
 * @summary Effects de feedback para el reporte tributario por período.
 * @description
 * Reacciona a errores en la carga de los três conjuntos de datos (ventas, compras,
 * consolidado) y muestra toasts de error. Usa Angular Signals con `effect`
 * para reactividad sin suscripciones manuales.
 */
@Injectable()
export class ReporteTributarioFeedbackEffects {

  private readonly store = inject(ReporteTributarioStore);
  private readonly toast = inject(ToastService);

  constructor() {
    this.errorVentasEffect();
    this.errorComprasEffect();
    this.errorConsolidadoEffect();
  }

  private errorVentasEffect() {
    effect(() => {
      const error = this.store.errorVentas();
      if (error) {
        this.toast.danger(error);
        this.store.setErrorVentas(null);
      }
    });
  }

  private errorComprasEffect() {
    effect(() => {
      const error = this.store.errorCompras();
      if (error) {
        this.toast.danger(error);
        this.store.setErrorCompras(null);
      }
    });
  }

  private errorConsolidadoEffect() {
    effect(() => {
      const error = this.store.errorConsolidado();
      if (error) {
        this.toast.danger(error);
        this.store.setErrorConsolidado(null);
      }
    });
  }
}
