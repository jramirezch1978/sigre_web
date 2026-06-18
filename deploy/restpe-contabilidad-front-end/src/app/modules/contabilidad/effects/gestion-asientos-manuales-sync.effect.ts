import { effect, inject, Injectable, untracked } from '@angular/core';
import { GestionAsientosManualesStore } from '../store/gestion-asientos-manuales.store';
import { GestionAsientosManualesFacade } from '../application/facades/gestion-asientos-manuales.facade';

/**
 * GestionAsientosManualesSyncEffects — Efectos de sincronización de datos.
 * Refresca la lista de asientos después de cada operación de escritura
 * para mantener la tabla siempre actualizada.
 */
@Injectable()
export class GestionAsientosManualesSyncEffects {

  private readonly store  = inject(GestionAsientosManualesStore);
  private readonly facade = inject(GestionAsientosManualesFacade);

  constructor() {
    this.refrescarDespuesDeGuardar();
    this.refrescarDespuesDeActualizar();
    this.refrescarDespuesDeAnular();
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

  private refrescarDespuesDeAnular(): void {
    effect(() => {
      if (this.store.resultAnular()) {
        untracked(() => this.facade.cargarItems());
      }
    });
  }
}
