import { Injectable, inject, effect } from '@angular/core';
import { RegistroFacturaFacade } from '../application/facades/registro-factura.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class RegistroFacturaFeedbackEffects {
  private readonly facade = inject(RegistroFacturaFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar las facturas: ${err}`);
      }
    });

    effect(() => {
      const err = this.facade.errorGuardar();
      if (err) {
        this.toast.danger(`Error al guardar la factura: ${err}`);
      }
    });

    effect(() => {
      const err = this.facade.errorActualizar();
      if (err) {
        this.toast.danger(`Error al actualizar la factura: ${err}`);
      }
    });
  }
}
