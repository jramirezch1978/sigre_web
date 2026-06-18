import { Injectable, inject, effect } from '@angular/core';
import { CerrarLiqAdelantosFacade } from '../application/facades/cerrar-liq-adelantos.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class CerrarLiqAdelantosFeedbackEffects {
  private readonly facade = inject(CerrarLiqAdelantosFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar liquidaciones: ${err}`);
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
