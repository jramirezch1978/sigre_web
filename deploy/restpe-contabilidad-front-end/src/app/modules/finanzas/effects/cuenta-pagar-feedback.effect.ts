import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CuentaPagarFacade } from '../application/facades/cuenta-pagar.facade';

@Injectable()
export class CuentaPagarFeedbackEffects {
  private readonly facade = inject(CuentaPagarFacade);
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
