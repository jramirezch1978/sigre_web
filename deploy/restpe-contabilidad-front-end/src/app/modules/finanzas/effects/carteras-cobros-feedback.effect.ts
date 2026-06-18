import { Injectable, inject, effect } from '@angular/core';
import { CarterasCobrosFacade } from '../application/facades/carteras-cobros.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class CarterasCobrosFeedbackEffects {
  private readonly facade = inject(CarterasCobrosFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar carteras de cobros: ${err}`);
      }
    });

    effect(() => {
      const err = this.facade.errorActualizar();
      if (err) {
        this.toast.danger(`Error al actualizar cartera de cobros: ${err}`);
      }
    });
  }
}
