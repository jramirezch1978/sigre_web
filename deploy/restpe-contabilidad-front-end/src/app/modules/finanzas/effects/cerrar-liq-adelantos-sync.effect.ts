import { Injectable, inject, effect } from '@angular/core';
import { CerrarLiqAdelantosFacade } from '../application/facades/cerrar-liq-adelantos.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class CerrarLiqAdelantosSyncEffects {
  private readonly facade = inject(CerrarLiqAdelantosFacade);
  private readonly toast = inject(ToastService);

  constructor() {
    effect(() => {
      if (this.facade.actualizadoOk()) {
        const mensaje = this.facade.mensajeExito();
        this.toast.success(mensaje ?? '¡Liquidación actualizada exitosamente!');
        this.facade.limpiarExito();
      }
    });
  }
}
