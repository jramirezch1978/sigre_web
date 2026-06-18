import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ConciliacionFacade } from '../application/facades/conciliacion.facade';

@Injectable()
export class ConciliacionFeedbackEffects {
  private readonly facade = inject(ConciliacionFacade);
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
