import { Injectable, inject, effect, untracked } from '@angular/core';
import { TipoDeCambioStore } from '../store/tipo-de-cambio.store';
import { TipoDeCambioFacade } from '../application/facades/tipo-de-cambio.facade';

@Injectable()
export class TipoDeCambioSyncEffects {

  private readonly store = inject(TipoDeCambioStore);
  private readonly facade = inject(TipoDeCambioFacade);

  constructor() {
    this.refrescarDespuesDeGuardar();
    this.refrescarDespuesDeActualizar();
    this.refrescarDespuesDeEliminar();
  }

  // ── Efectos ──────────────────────────────────────────────────────────────

  private refrescarDespuesDeGuardar(): void {
    effect(() => {
      const result = this.store.resultGuardar();
      if (!result?.success) return;

      untracked(() => {
        this.facade.cargarItems();
      });
    });
  }

  private refrescarDespuesDeActualizar(): void {
    effect(() => {
      const result = this.store.resultActualizar();
      if (!result?.success) return;

      untracked(() => {
        this.facade.cargarItems();
      });
    });
  }

  private refrescarDespuesDeEliminar(): void {
    effect(() => {
      const result = this.store.resultEliminar();
      if (!result?.success) return;

      untracked(() => {
        this.facade.cargarItems();
      });
    });
  }
}
