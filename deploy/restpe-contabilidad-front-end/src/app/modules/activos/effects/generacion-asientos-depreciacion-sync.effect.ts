import { Injectable, inject, effect } from '@angular/core';
import { GeneracionAsientosDepreciacionStore } from '../store/generacion-asientos-depreciacion.store';
import { GeneracionAsientosDepreciacionFacade } from '../application/facades/generacion-asientos-depreciacion.facade';

@Injectable()
export class GeneracionAsientosDepreciacionSyncEffects {
  private readonly store  = inject(GeneracionAsientosDepreciacionStore);
  private readonly facade = inject(GeneracionAsientosDepreciacionFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarAsientos();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarAsientos();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarAsientos();
      }
    });
  }
}
