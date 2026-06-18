import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CruceExtractoFacade } from '../application/facades/cruce-extracto.facade';

@Injectable()
export class CruceExtractoFeedbackEffects {
  private readonly facade = inject(CruceExtractoFacade);
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
