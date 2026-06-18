import { Injectable, inject, effect } from '@angular/core';
import { IncidenciaStore } from '../store/incidencia.store';
import { IncidenciaFacade } from '../application/facades/incidencia.facade';

/**
 * Effect que sincroniza automáticamente la lista de incidencias
 * después de guardar, actualizar o eliminar.
 */
@Injectable()
export class IncidenciaSyncEffects {
  private readonly store   = inject(IncidenciaStore);
  private readonly facade  = inject(IncidenciaFacade);

  constructor() {
    // Recargar tras guardar con éxito
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarIncidencias();
      }
    });

    // Recargar tras actualizar con éxito
    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarIncidencias();
      }
    });

    // Recargar tras eliminar con éxito
    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarIncidencias();
      }
    });
  }
}
