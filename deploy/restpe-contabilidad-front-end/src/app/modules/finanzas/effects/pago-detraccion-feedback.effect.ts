import { Injectable, inject, effect } from '@angular/core';
import { PagoDetraccionFacade } from '../application/facades/pago-detraccion.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class PagoDetraccionFeedbackEffects {
  private readonly facade = inject(PagoDetraccionFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar las detracciones: ${err}`);
      }
    });
  }
}
