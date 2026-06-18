import { Injectable, inject, effect } from '@angular/core';
import { PagoRecibidoFacade } from '../application/facades/pago-recibido.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class PagoRecibidoFeedbackEffects {
  private readonly facade = inject(PagoRecibidoFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    // Error al obtener
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar pagos recibidos: ${err}`);
      }
    });
  }
}
