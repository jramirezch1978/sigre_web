import { Injectable, inject, effect } from '@angular/core';
import { PagosMasivosFacade } from '../application/facades/pagos-masivos.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class PagosMasivosFeedbackEffects {
  private readonly facade = inject(PagosMasivosFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      const err = this.facade.errorObtener();
      if (err) {
        this.toast.danger(`Error al cargar pagos masivos: ${err}`);
      }
    });

    effect(() => {
      const err = this.facade.errorGuardar();
      if (err) {
        this.toast.danger(`Error al guardar pago masivo: ${err}`);
      }
    });

    effect(() => {
      const err = this.facade.errorDocumentos();
      if (err) {
        this.toast.danger(`Error al cargar documentos: ${err}`);
      }
    });
  }
}
