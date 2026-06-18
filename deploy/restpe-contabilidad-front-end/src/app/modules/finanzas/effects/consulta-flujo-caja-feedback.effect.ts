import { Injectable, inject, effect } from '@angular/core';
import { ConsultaFlujoCajaFacade } from '../application/facades/consulta-flujo-caja.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class ConsultaFlujoCajaFeedbackEffects {
  private readonly facade = inject(ConsultaFlujoCajaFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar flujo de caja: ${err}`);
      }
    });
  }
}
