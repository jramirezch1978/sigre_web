import { Injectable, inject, effect } from '@angular/core';
import { NumTrasladoStore } from '../store/num-traslado.store';
import { NumTrasladoFacade } from '../application/facades/num-traslado.facade';

/**
 * Effect que recarga la lista de Numeradores de Traslados
 * automáticamente tras guardar, actualizar o eliminar.
 */
@Injectable()
export class NumTrasladoSyncEffects {
  private readonly store  = inject(NumTrasladoStore);
  private readonly facade = inject(NumTrasladoFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarNumTraslados();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarNumTraslados();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarNumTraslados();
      }
    });
  }
}
