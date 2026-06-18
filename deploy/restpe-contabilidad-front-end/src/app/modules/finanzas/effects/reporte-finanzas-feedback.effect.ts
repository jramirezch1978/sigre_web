import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ReporteFinanzasFacade } from '../application/facades/reporte-finanzas.facade';

@Injectable()
export class ReporteFinanzasFeedbackEffects {
  private readonly facade = inject(ReporteFinanzasFacade);
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
