import { Injectable, inject, effect } from '@angular/core';
import { OrdenGiroFacade } from '../application/facades/orden-giro.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class OrdenGiroSyncEffects {
  private readonly facade = inject(OrdenGiroFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      if (this.facade.guardadoOk()) {
        this.toast.success('¡Orden guardada exitosamente!');
      }
    });

    effect(() => {
      if (this.facade.actualizadoOk()) {
        this.toast.success('¡Orden actualizada exitosamente!');
      }
    });
  }
}
