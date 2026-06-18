import { Injectable, inject, effect } from '@angular/core';
import { RegistroEgresoMenorFacade } from '../application/facades/registro-egreso-menor.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class RegistroEgresoMenorFeedbackEffects {
  private readonly facade = inject(RegistroEgresoMenorFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar los registros de egreso menor: ${err}`);
      }
    });
  }
}
