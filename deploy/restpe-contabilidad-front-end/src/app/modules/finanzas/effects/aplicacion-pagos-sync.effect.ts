import { Injectable, inject, effect } from '@angular/core';
import { AplicacionPagosFacade } from '../application/facades/aplicacion-pagos.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class AplicacionPagosSyncEffects {
  private readonly facade = inject(AplicacionPagosFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      if (this.facade.guardadoOk()) {
        this.toast.success('¡Registro de pago/anticipo registrado exitosamente!');
      }
    });

    effect(() => {
      if (this.facade.actualizadoOk()) {
        this.toast.success('¡Se guardaron cambios exitosamente!');
      }
    });
  }
}
