import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { RegistroIngresoDeDiaFacade } from '../application/facades/registro-ingreso-de-dia.facade';

@Injectable()
export class RegistroIngresoDeDiaFeedbackEffects {
  private readonly facade = inject(RegistroIngresoDeDiaFacade);
  private readonly toastService = inject(ToastService);

  constructor() {
    effect(() => {
      const error = this.facade.error();
      if (error) {
        this.toastService.danger(error);
      }
    });
  }
}
