import { Injectable, inject, effect } from '@angular/core';
import { GeneracionAsientosRevaluacionStore } from '../store/generacion-asientos-revaluacion.store';
import { GeneracionAsientosRevaluacionFacade } from '../application/facades/generacion-asientos-revaluacion.facade';

@Injectable()
export class GeneracionAsientosRevaluacionSyncEffects {
  private readonly store  = inject(GeneracionAsientosRevaluacionStore);
  private readonly facade = inject(GeneracionAsientosRevaluacionFacade);

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
