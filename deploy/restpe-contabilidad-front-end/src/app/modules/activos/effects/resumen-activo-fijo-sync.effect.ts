import { Injectable, inject, effect } from '@angular/core';
import { ResumenActivoFijoStore } from '../store/resumen-activo-fijo.store';
import { ResumenActivoFijoFacade } from '../application/facades/resumen-activo-fijo.facade';

@Injectable()
export class ResumenActivoFijoSyncEffects {
  private readonly store  = inject(ResumenActivoFijoStore);
  private readonly facade = inject(ResumenActivoFijoFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarResumenes();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarResumenes();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarResumenes();
      }
    });
  }
}
