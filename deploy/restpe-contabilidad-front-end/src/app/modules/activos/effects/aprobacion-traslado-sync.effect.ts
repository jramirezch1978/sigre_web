import { Injectable, inject, effect } from '@angular/core';
import { AprobacionTrasladoStore } from '../store/aprobacion-traslado.store';
import { AprobacionTrasladoFacade } from '../application/facades/aprobacion-traslado.facade';

@Injectable()
export class AprobacionTrasladoSyncEffects {
  private readonly store  = inject(AprobacionTrasladoStore);
  private readonly facade = inject(AprobacionTrasladoFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarTraslados();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarTraslados();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarTraslados();
      }
    });
  }
}
