import { Injectable, inject, effect } from '@angular/core';
import { AprobarGiroFacade } from '../application/facades/aprobar-giro.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class AprobarGiroFeedbackEffects {
  private readonly facade = inject(AprobarGiroFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar órdenes de giro: ${err}`);
      }
    });

    effect(() => {
      const err = this.facade.errorActualizar();
      if (err) {
        this.toast.danger(`Error al actualizar orden de giro: ${err}`);
      }
    });
  }
}
