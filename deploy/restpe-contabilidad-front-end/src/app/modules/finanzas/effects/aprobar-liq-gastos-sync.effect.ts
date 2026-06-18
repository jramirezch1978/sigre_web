import { Injectable, inject, effect } from '@angular/core';
import { AprobarLiqGastosFacade } from '../application/facades/aprobar-liq-gastos.facade';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class AprobarLiqGastosSyncEffects {
  private readonly facade = inject(AprobarLiqGastosFacade);
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
