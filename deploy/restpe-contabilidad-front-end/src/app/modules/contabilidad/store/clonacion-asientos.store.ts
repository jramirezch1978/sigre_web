import { Injectable, computed, signal } from '@angular/core';
import { ClonacionAsientosState, initialClonacionAsientosState } from './clonacion-asientos.state';
import { ClonacionAsientosEntity } from '../domain/models/clonacion-asientos.entity';

/**
 * ClonacionAsientosStore — Store reactivo de señales.
 * Gestiona el estado del proceso de clonación de asientos.
 */
@Injectable()
export class ClonacionAsientosStore {

  private readonly state = signal<ClonacionAsientosState>(initialClonacionAsientosState);

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

  setData(data: ClonacionAsientosEntity): void {
    this.state.update(s => ({ ...s, data, errorObtener: null, loadingObtener: false }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  resetState(): void {
    this.state.set(initialClonacionAsientosState);
  }
}
