import { effect, inject, Injectable } from '@angular/core';
import { CentroCostoStore } from '../store/centro-costo.store';
import { CentroCostoFacade } from '../application/facades/plan-centro-costos.facade';

@Injectable()
export class CentroCostoSyncEffects {

  private readonly store = inject(CentroCostoStore);
  private readonly facade = inject(CentroCostoFacade);

  constructor() {
    this.refrescarDespuesDeGuardar();
    this.refrescarDespuesDeEliminar();
    this.refrescarDespuesDeActualizar();
  }

  private refrescarDespuesDeGuardar(): void {
    effect(() => {
      if (this.store.resultGuardar()) {
        this.facade.cargarCentrosCosto();
      }
    });
  }

  private refrescarDespuesDeEliminar(): void {
    effect(() => {
      if (this.store.resultEliminar()) {
        this.facade.cargarCentrosCosto();
      }
    });
  }

  private refrescarDespuesDeActualizar(): void {
    effect(() => {
      if (this.store.resultActualizar()) {
        this.facade.cargarCentrosCosto();
      }
    });
  }
}
