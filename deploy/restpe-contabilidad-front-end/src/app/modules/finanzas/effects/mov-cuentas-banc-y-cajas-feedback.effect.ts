import { Injectable, inject, effect } from '@angular/core';
import { MovCuentasBancYCajasFacade } from '../application/facades/mov-cuentas-banc-y-cajas.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class MovCuentasBancYCajasFeedbackEffects {
  private readonly facade = inject(MovCuentasBancYCajasFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    // Error al obtener
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar movimientos entre cuentas bancarias y cajas: ${err}`);
      }
    });
  }
}
