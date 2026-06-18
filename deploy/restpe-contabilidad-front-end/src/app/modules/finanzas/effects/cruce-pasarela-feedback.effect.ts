import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CrucePasarelaFacade } from '../application/facades/cruce-pasarela.facade';

@Injectable()
export class CrucePasarelaFeedbackEffects {
  private readonly facade = inject(CrucePasarelaFacade);
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
