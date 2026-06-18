import { Injectable, inject, effect } from '@angular/core';
import { AsignacionRatiosStore } from '../store/asignacion-ratios.store';
import { AsignacionRatiosFacade } from '../application/facades/asignacion-ratios.facade';

@Injectable()
export class AsignacionRatiosSyncEffects {
  private readonly store  = inject(AsignacionRatiosStore);
  private readonly facade = inject(AsignacionRatiosFacade);

  constructor() {
    effect(() => {
      const result = this.store.resultGuardar();
      if (result?.success) {
        this.facade.cargarAsignaciones();
      }
    });

    effect(() => {
      const result = this.store.resultActualizar();
      if (result?.success) {
        this.facade.cargarAsignaciones();
      }
    });

    effect(() => {
      const result = this.store.resultEliminar();
      if (result?.success) {
        this.facade.cargarAsignaciones();
      }
    });
  }
}
