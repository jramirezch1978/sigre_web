import { Injectable, effect, inject } from '@angular/core';
import { CanjeReprogramacionStore } from '../store/canje-reprogramacion.store';
import { CanjeReprogramacionFacade } from '../application/facades/canje-reprogramacion.facade';

@Injectable()
export class CanjeReprogramacionSyncEffects {
  private readonly store = inject(CanjeReprogramacionStore);
  private readonly facade = inject(CanjeReprogramacionFacade);

  private readonly recargarTrasCanjeEffect = effect(() => {
    const result = this.store.resultCanje();
    if (result?.success) {
      this.store.setResultCanje(null);
      this.facade.cargarRegistros();
    }
  });

  private readonly recargarTrasReprogramarEffect = effect(() => {
    const result = this.store.resultReprogramar();
    if (result?.success) {
      this.store.setResultReprogramar(null);
      this.facade.cargarRegistros();
    }
  });
}
