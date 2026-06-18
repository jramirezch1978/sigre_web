import { Injectable, inject, effect } from '@angular/core';
import { LiqRendicionFacade } from '../application/facades/liq-rendicion.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class LiqRendicionFeedbackEffects {
  private readonly facade = inject(LiqRendicionFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar liquidaciones: ${err}`);
      }
    });

    effect(() => {
      const err = this.facade.errorGuardar();
      if (err) {
        this.toast.danger(`Error al guardar liquidación: ${err}`);
      }
    });

    effect(() => {
      const err = this.facade.errorActualizar();
      if (err) {
        this.toast.danger(`Error al actualizar liquidación: ${err}`);
      }
    });
  }
}
