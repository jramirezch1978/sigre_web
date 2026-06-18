import { Injectable, inject, effect } from '@angular/core';
import { SeguroStore } from '../store/seguro.store';
import { SeguroFacade } from '../application/facades/seguro.facade';

@Injectable()
export class SeguroSyncEffects {
  private readonly store  = inject(SeguroStore);
  private readonly facade = inject(SeguroFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarSeguros();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarSeguros();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarSeguros();
      }
    });
  }
}
