import { Injectable, inject, effect } from '@angular/core';
import { CalculoDepreciacionStore } from '../store/calculo-depreciacion.store';
import { CalculoDepreciacionFacade } from '../application/facades/calculo-depreciacion.facade';

@Injectable()
export class CalculoDepreciacionSyncEffects {
  private readonly store  = inject(CalculoDepreciacionStore);
  private readonly facade = inject(CalculoDepreciacionFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarCalculos();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarCalculos();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarCalculos();
      }
    });
  }
}
