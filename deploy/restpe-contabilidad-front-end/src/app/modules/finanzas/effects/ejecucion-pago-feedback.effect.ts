import { Injectable, inject, effect } from '@angular/core';
import { EjecucionPagoFacade } from '../application/facades/ejecucion-pago.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class EjecucionPagoFeedbackEffects {
  private readonly facade = inject(EjecucionPagoFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar pagos de ejecución: ${err}`);
      }
    });

    effect(() => {
      const err = this.facade.errorGuardar();
      if (err) {
        this.toast.danger(`Error al guardar el pago: ${err}`);
      }
    });

    effect(() => {
      const err = this.facade.errorAnular();
      if (err) {
        this.toast.danger(`Error al anular el pago: ${err}`);
      }
    });
  }
}
