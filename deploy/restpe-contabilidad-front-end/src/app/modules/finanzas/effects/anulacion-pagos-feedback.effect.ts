import { Injectable, inject, effect } from '@angular/core';
import { AnulacionPagosFacade } from '../application/facades/anulacion-pagos.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class AnulacionPagosFeedbackEffects {
  private readonly facade = inject(AnulacionPagosFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    // Error al obtener
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar anulaciones/reversiones de pagos: ${err}`);
      }
    });
  }
}
