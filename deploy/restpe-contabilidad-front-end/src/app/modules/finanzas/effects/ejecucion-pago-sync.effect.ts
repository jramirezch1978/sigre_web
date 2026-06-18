import { Injectable, inject, effect } from '@angular/core';
import { EjecucionPagoFacade } from '../application/facades/ejecucion-pago.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class EjecucionPagoSyncEffects {
  private readonly facade = inject(EjecucionPagoFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      if (this.facade.guardadoOk()) {
        this.toast.success('¡Pago guardado exitosamente!');
        this.facade.limpiarExito();
      }
    });

    effect(() => {
      if (this.facade.anuladoOk()) {
        this.toast.success('¡La acción se realizó con éxito!');
        this.facade.limpiarExito();
      }
    });
  }
}
