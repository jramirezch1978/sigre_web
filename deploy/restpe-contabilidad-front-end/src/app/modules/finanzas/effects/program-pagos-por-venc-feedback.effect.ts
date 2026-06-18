import { Injectable, inject, effect } from '@angular/core';
import { ProgramPagosPorVencFacade } from '../application/facades/program-pagos-por-venc.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class ProgramPagosPorVencFeedbackEffects {
  private readonly facade = inject(ProgramPagosPorVencFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar pagos programados por vencimiento: ${err}`);
      }
    });
  }
}
