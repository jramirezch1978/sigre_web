import { Injectable, inject, effect } from '@angular/core';
import { OrdenGiroFacade } from '../application/facades/orden-giro.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class OrdenGiroFeedbackEffects {
  private readonly facade = inject(OrdenGiroFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar órdenes de giro: ${err}`);
      }
    });

    effect(() => {
      const err = this.facade.errorGuardar();
      if (err) {
        this.toast.danger(`Error al guardar orden de giro: ${err}`);
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
