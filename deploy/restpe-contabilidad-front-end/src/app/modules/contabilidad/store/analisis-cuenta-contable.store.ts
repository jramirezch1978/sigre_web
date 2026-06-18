import { Injectable, computed, signal } from '@angular/core';
import { AnalisisCuentaContableState, initialAnalisisCuentaContableState } from './analisis-cuenta-contable.state';
import { AnalisisCuentaContableEntity } from '../domain/models/analisis-cuenta-contable.entity';

/**
 * AnalisisCuentaContableStore — Store reactivo de señales.
 * Gestiona el estado del análisis de cuenta contable.
 */
@Injectable()
export class AnalisisCuentaContableStore {

  private readonly state = signal<AnalisisCuentaContableState>(initialAnalisisCuentaContableState);

  // ── Selectores de datos ──────────────────────────────────────────────────

  readonly data    = computed(() => this.state().data);
  readonly items   = computed(() => this.state().data.items);

  // ── Selectores de loading / error ────────────────────────────────────────

  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly isLoading      = computed(() => this.state().loadingObtener);
  readonly errorObtener   = computed(() => this.state().errorObtener);
  readonly hasError       = computed(() => !!this.state().errorObtener);

  // ── Mutaciones ───────────────────────────────────────────────────────────

  setLoadingObtener(value: boolean): void {
    this.state.update(s => ({ ...s, loadingObtener: value }));
  }

  setData(data: AnalisisCuentaContableEntity): void {
    this.state.update(s => ({ ...s, data, errorObtener: null, loadingObtener: false }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  resetState(): void {
    this.state.set(initialAnalisisCuentaContableState);
  }
}
