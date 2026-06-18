import { effect, inject, Injectable } from '@angular/core';
import { CuentaVsSubcategoriaStore } from '../store/cuenta-vs-subcategoria.store';
import { CuentaVsSubcategoriaFacade } from '../application/facades/cuenta-vs-subcategoria.facade';

@Injectable()
export class CuentaVsSubcategoriaSyncEffects {

  private readonly store = inject(CuentaVsSubcategoriaStore);
  private readonly facade = inject(CuentaVsSubcategoriaFacade);

  constructor() {
    this.refrescarDespuesDeActualizar();
  }

  private refrescarDespuesDeActualizar(): void {
    effect(() => {
      if (this.store.resultActualizar()) {
        this.facade.cargarItems();
      }
    });
  }
}
