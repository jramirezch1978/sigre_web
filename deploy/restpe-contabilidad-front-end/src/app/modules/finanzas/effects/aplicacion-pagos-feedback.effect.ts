import { Injectable, inject, effect } from '@angular/core';
import { AplicacionPagosFacade } from '../application/facades/aplicacion-pagos.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class AplicacionPagosFeedbackEffects {
  private readonly facade = inject(AplicacionPagosFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar aplicación de pagos: ${err}`);
      }
    });

    effect(() => {
      const err = this.facade.errorGuardar();
      if (err) {
        this.toast.danger(`Error al guardar registro: ${err}`);
      }
    });

    effect(() => {
      const err = this.facade.errorActualizar();
      if (err) {
        this.toast.danger(`Error al actualizar registro: ${err}`);
      }
    });
  }
}
