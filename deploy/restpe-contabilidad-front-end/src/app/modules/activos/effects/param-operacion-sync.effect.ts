import { Injectable, inject, effect } from '@angular/core';
import { ParamOperacionStore } from '../store/param-operacion.store';
import { ParamOperacionFacade } from '../application/facades/param-operacion.facade';

/**
 * Effect que recarga los Parámetros de Operaciones
 * automáticamente tras guardar o actualizar.
 */
@Injectable()
export class ParamOperacionSyncEffects {
  private readonly store  = inject(ParamOperacionStore);
  private readonly facade = inject(ParamOperacionFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarParamOperaciones();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarParamOperaciones();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarParamOperaciones();
      }
    });
  }
}
