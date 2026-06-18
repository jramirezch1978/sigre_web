import { effect, inject, Injectable, untracked } from '@angular/core';
import { TablaImpuestoStore } from '../store/tabla-impuesto.store';
import { TablaImpuestoFacade } from '../application/facades/tabla-impuesto.facade';

@Injectable()
export class TablaImpuestoSyncEffects {

  private readonly store = inject(TablaImpuestoStore);
  private readonly facade = inject(TablaImpuestoFacade);

  constructor() {
    this.refrescarDespuesDeGuardar();
    this.refrescarDespuesDeActualizar();
  }

  // ── Efectos ──────────────────────────────────────────────────────────────

  private refrescarDespuesDeGuardar(): void {
    effect(() => {
      if (this.store.resultGuardar()) {
        untracked(() => this.facade.cargarItems());
      }
    });
  }

  private refrescarDespuesDeActualizar(): void {
    effect(() => {
      if (this.store.resultActualizar()) {
        untracked(() => this.facade.cargarItems());
      }
    });
  }
}
