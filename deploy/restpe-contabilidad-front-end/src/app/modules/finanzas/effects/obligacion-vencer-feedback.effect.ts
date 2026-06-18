import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ObligacionVencerFacade } from '../application/facades/obligacion-vencer.facade';

@Injectable()
export class ObligacionVencerFeedbackEffects {
  private readonly facade = inject(ObligacionVencerFacade);
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
