import { Injectable, inject, effect } from '@angular/core';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ProyeccionIngresosEgresosFacade } from '../application/facades/proyeccion-ingresos-egresos.facade';

@Injectable()
export class ProyeccionIngresosEgresosFeedbackEffects {
  private readonly facade = inject(ProyeccionIngresosEgresosFacade);
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
