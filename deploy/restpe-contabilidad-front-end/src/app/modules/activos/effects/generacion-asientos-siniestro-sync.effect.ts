import { Injectable, inject, effect } from '@angular/core';
import { GeneracionAsientosSiniestroStore } from '../store/generacion-asientos-siniestro.store';
import { GeneracionAsientosSiniestroFacade } from '../application/facades/generacion-asientos-siniestro.facade';

@Injectable()
export class GeneracionAsientosSiniestroSyncEffects {
  private readonly store  = inject(GeneracionAsientosSiniestroStore);
  private readonly facade = inject(GeneracionAsientosSiniestroFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarSiniestros();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarSiniestros();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarSiniestros();
      }
    });
  }
}
