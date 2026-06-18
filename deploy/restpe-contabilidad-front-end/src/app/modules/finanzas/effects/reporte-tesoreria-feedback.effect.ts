import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ReporteTesoreriaFacade } from '../application/facades/reporte-tesoreria.facade';

@Injectable()
export class ReporteTesoreriaFeedbackEffects {
  private readonly facade = inject(ReporteTesoreriaFacade);
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
