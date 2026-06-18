import { Injectable, inject, effect } from '@angular/core';
import { OperacionStore } from '../store/operacion.store';
import { OperacionFacade } from '../application/facades/operacion.facade';

/**
 * Effect que recarga la lista de Operaciones
 * automáticamente tras guardar, actualizar o eliminar.
 */
@Injectable()
export class OperacionSyncEffects {
  private readonly store  = inject(OperacionStore);
  private readonly facade = inject(OperacionFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarOperaciones();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarOperaciones();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarOperaciones();
      }
    });
  }
}
