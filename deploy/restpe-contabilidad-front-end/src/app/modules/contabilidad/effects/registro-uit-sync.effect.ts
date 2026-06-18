import { effect, inject, Injectable, untracked } from '@angular/core';
import { RegistroUitStore } from '../store/registro-uit.store';
import { RegistroUitFacade } from '../application/facades/registro-uit.facade';

/**
 * RegistroUitSyncEffects — Efectos de sincronización de datos.
 * Refresca la lista de registros UIT después de cada operación de escritura
 * para mantener la tabla siempre actualizada.
 */
@Injectable()
export class RegistroUitSyncEffects {

  private readonly store  = inject(RegistroUitStore);
  private readonly facade = inject(RegistroUitFacade);

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
