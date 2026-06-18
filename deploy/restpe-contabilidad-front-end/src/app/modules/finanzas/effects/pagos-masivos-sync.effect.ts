import { Injectable, inject, effect } from '@angular/core';
import { PagosMasivosFacade } from '../application/facades/pagos-masivos.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class PagosMasivosSyncEffects {
  private readonly facade = inject(PagosMasivosFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      if (this.facade.guardadoOk()) {
        this.toast.success('¡Pago masivo registrado exitosamente!');
        this.facade.limpiarExito();
      }
    });
  }
}
