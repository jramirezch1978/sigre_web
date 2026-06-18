import { Injectable, computed, signal } from '@angular/core';
import { ConsistenciaAsientosState, initialConsistenciaAsientosState } from './consistencia-asientos.state';
import { ConsistenciaAsientosEntity } from '../domain/models/consistencia-asientos.entity';

@Injectable()
export class ConsistenciaAsientosStore {

  private readonly state = signal<ConsistenciaAsientosState>(initialConsistenciaAsientosState);

  // ── Selectores ───────────────────────────────────────────────────────────

  readonly items          = computed(() => this.state().items);
  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly isLoading      = computed(() => this.state().loadingObtener);
  readonly errorObtener   = computed(() => this.state().errorObtener);
  readonly hasError       = computed(() => !!this.state().errorObtener);

  // ── Mutaciones ───────────────────────────────────────────────────────────

  setLoadingObtener(value: boolean): void {
    this.state.update(s => ({ ...s, loadingObtener: value }));
  }

  setItems(items: ConsistenciaAsientosEntity[]): void {
    this.state.update(s => ({ ...s, items, errorObtener: null, loadingObtener: false }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  resetState(): void {
    this.state.set(initialConsistenciaAsientosState);
  }
}

