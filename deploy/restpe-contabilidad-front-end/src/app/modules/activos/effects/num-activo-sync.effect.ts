import { Injectable, inject, effect } from '@angular/core';
import { NumActivoStore } from '../store/num-activo.store';
import { NumActivoFacade } from '../application/facades/num-activo.facade';

/**
 * Effect que recarga la lista de Numeradores de Activos
 * automáticamente tras guardar, actualizar o eliminar.
 */
@Injectable()
export class NumActivoSyncEffects {
  private readonly store  = inject(NumActivoStore);
  private readonly facade = inject(NumActivoFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarNumActivos();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarNumActivos();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarNumActivos();
      }
    });
  }
}
