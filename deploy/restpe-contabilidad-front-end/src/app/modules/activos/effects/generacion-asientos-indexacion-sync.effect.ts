import { Injectable, inject, effect } from '@angular/core';
import { GeneracionAsientosIndexacionStore } from '../store/generacion-asientos-indexacion.store';
import { GeneracionAsientosIndexacionFacade } from '../application/facades/generacion-asientos-indexacion.facade';

/**
 * Efectos de sincronización para Generación de Asientos de Indexación.
 * Recarga la lista tras operaciones de escritura exitosas.
 */
@Injectable()
export class GeneracionAsientosIndexacionSyncEffects {
  private readonly store  = inject(GeneracionAsientosIndexacionStore);
  private readonly facade = inject(GeneracionAsientosIndexacionFacade);

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
