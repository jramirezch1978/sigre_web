import { Injectable, inject, effect } from '@angular/core';
import { DepreciacionAnualStore } from '../store/depreciacion-anual.store';
import { DepreciacionAnualFacade } from '../application/facades/depreciacion-anual.facade';

@Injectable()
export class DepreciacionAnualSyncEffects {
  private readonly store  = inject(DepreciacionAnualStore);
  private readonly facade = inject(DepreciacionAnualFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarDepreciaciones();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarDepreciaciones();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarDepreciaciones();
      }
    });
  }
}
