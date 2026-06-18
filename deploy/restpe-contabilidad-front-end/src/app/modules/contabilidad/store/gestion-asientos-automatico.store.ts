import { Injectable, computed, signal } from '@angular/core';
import { GestionAsientosAutomaticoState, initialGestionAsientosAutomaticoState } from './gestion-asientos-automatico.state';
import { GestionAsientosAutomaticoEntity } from '../domain/models/gestion-asientos-automatico.entity';

/**
 * GestionAsientosAutomaticoStore — Store reactivo de señales.
 * Gestiona el estado de la lista de asientos automáticos.
 */
@Injectable()
export class GestionAsientosAutomaticoStore {

  private readonly state = signal<GestionAsientosAutomaticoState>(initialGestionAsientosAutomaticoState);

  // ── Selectores de datos ──────────────────────────────────────────────────

  readonly data  = computed(() => this.state().data);
  readonly items = computed(() => this.state().data.items);

  // ── Selectores de loading / error ────────────────────────────────────────

  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly isLoading      = computed(() => this.state().loadingObtener);
  readonly errorObtener   = computed(() => this.state().errorObtener);
  readonly hasError       = computed(() => !!this.state().errorObtener);

  // ── Mutaciones ───────────────────────────────────────────────────────────

  setLoadingObtener(value: boolean): void {
    this.state.update(s => ({ ...s, loadingObtener: value }));
  }

  setData(data: GestionAsientosAutomaticoEntity): void {
    this.state.update(s => ({ ...s, data, errorObtener: null, loadingObtener: false }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  resetState(): void {
    this.state.set(initialGestionAsientosAutomaticoState);
  }
}
