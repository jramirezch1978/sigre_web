import { Injectable, computed, signal } from '@angular/core';
import { MaestroContableState, initialMaestroContableState } from './maestro-contable.state';
import { MaestroContableEntity } from '../domain/models/maestro-contable.entity';

@Injectable()
export class MaestroContableStore {

  private readonly state = signal<MaestroContableState>(initialMaestroContableState);

  // ── Selectores de datos ──────────────────────────────────────────────────

  readonly data           = computed(() => this.state().data);
  readonly planCuentas    = computed(() => this.state().data.planCuentas);
  readonly centroCosto    = computed(() => this.state().data.centroCosto);
  readonly impuestos      = computed(() => this.state().data.impuestos);
  readonly tiposDetraccion = computed(() => this.state().data.tiposDetraccion);
  readonly configuraciones = computed(() => this.state().data.configuraciones);

  // ── Selectores de loading / error ────────────────────────────────────────

  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly isLoading      = computed(() => this.state().loadingObtener);
  readonly errorObtener   = computed(() => this.state().errorObtener);
  readonly hasError       = computed(() => !!this.state().errorObtener);

  // ── Mutaciones ───────────────────────────────────────────────────────────

  setLoadingObtener(value: boolean): void {
    this.state.update(s => ({ ...s, loadingObtener: value }));
  }

  setData(data: MaestroContableEntity): void {
    this.state.update(s => ({ ...s, data, errorObtener: null, loadingObtener: false }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  resetState(): void {
    this.state.set(initialMaestroContableState);
  }
}
