import { Injectable, inject, effect } from '@angular/core';
import { ResumenRangosStore } from '../store/resumen-rangos.store';
import { ResumenRangosFacade } from '../application/facades/resumen-rangos.facade';

@Injectable()
export class ResumenRangosSyncEffects {
  private readonly store  = inject(ResumenRangosStore);
  private readonly facade = inject(ResumenRangosFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarRangos();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarRangos();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarRangos();
      }
    });
  }
}
