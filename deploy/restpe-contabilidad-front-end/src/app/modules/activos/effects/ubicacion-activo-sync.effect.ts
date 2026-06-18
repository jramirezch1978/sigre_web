import { Injectable, inject, effect } from '@angular/core';
import { UbicacionActivoStore } from '../store/ubicacion-activo.store';
import { UbicacionActivoFacade } from '../application/facades/ubicacion-activo.facade';

@Injectable()
export class UbicacionActivoSyncEffects {
  private readonly store  = inject(UbicacionActivoStore);
  private readonly facade = inject(UbicacionActivoFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarUbicaciones();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarUbicaciones();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarUbicaciones();
      }
    });
  }
}
