import { Injectable, inject, effect } from '@angular/core';
import { ConsultaCajaBancoFacade } from '../application/facades/consulta-caja-banco.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class ConsultaCajaBancoFeedbackEffects {
  private readonly facade = inject(ConsultaCajaBancoFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    // Error al obtener cuentas
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar cuentas de caja y banco: ${err}`);
      }
    });
  }
}
