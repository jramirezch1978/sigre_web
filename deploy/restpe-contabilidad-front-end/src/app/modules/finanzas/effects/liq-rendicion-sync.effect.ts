import { Injectable, inject, effect } from '@angular/core';
import { LiqRendicionFacade } from '../application/facades/liq-rendicion.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class LiqRendicionSyncEffects {
  private readonly facade = inject(LiqRendicionFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      if (this.facade.guardadoOk()) {
        this.toast.success('¡Liquidación registrada exitosamente!');
      }
    });

    effect(() => {
      if (this.facade.actualizadoOk()) {
        this.toast.success('¡Liquidación actualizada exitosamente!');
      }
    });
  }
}
