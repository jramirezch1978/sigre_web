import { effect, inject, Injectable } from '@angular/core';
import { DetraccionStore } from '../store/detraccion.store';
import { DetraccionFacade } from '../application/facades/detraccion.facade';

@Injectable()
export class DetraccionSyncEffects {

  private readonly store = inject(DetraccionStore);
  private readonly facade = inject(DetraccionFacade);

  constructor() {
    this.refrescarDespuesDeGuardar();
    this.refrescarDespuesDeEliminar();
    this.refrescarDespuesDeActualizar();
  }

  private refrescarDespuesDeGuardar(): void {
    effect(() => {
      if (this.store.resultGuardar()) {
        this.facade.cargarDetracciones();
      }
    });
  }

  private refrescarDespuesDeEliminar(): void {
    effect(() => {
      if (this.store.resultEliminar()) {
        this.facade.cargarDetracciones();
      }
    });
  }

  private refrescarDespuesDeActualizar(): void {
    effect(() => {
      if (this.store.resultActualizar()) {
        this.facade.cargarDetracciones();
      }
    });
  }
}
