import { Injectable, inject, effect } from '@angular/core';
import { CarterasCobrosFacade } from '../application/facades/carteras-cobros.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class CarterasCobrosSyncEffects {
  private readonly facade = inject(CarterasCobrosFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      if (this.facade.actualizadoOk()) {
        this.toast.success('¡Cambios guardados exitosamente!');
        this.facade.limpiarExito();
      }
    });
  }
}
