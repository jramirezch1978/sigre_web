import { Injectable, computed, signal } from '@angular/core';
import { PolizaSeguroState, initialPolizaSeguroState } from './poliza-seguro.state';
import { PolizaSeguroEntity } from '../domain/models/poliza-seguro.entity';

@Injectable()
export class PolizaSeguroStore {
  private readonly _state = signal<PolizaSeguroState>(initialPolizaSeguroState);

  // ── Selectores ──────────────────────────────────────────────────────────────
  readonly polizas        = computed(() => this._state().polizas);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly isLoading      = computed(() => this._state().loadingObtener);
  readonly errorObtener   = computed(() => this._state().errorObtener);

  // ── Setters ─────────────────────────────────────────────────────────────────
  setPolizas(items: PolizaSeguroEntity[])    { this._state.update(s => ({ ...s, polizas: items })); }
  setLoadingObtener(v: boolean)              { this._state.update(s => ({ ...s, loadingObtener: v })); }
  setErrorObtener(e: string | null)          { this._state.update(s => ({ ...s, errorObtener: e })); }

  reset() { this._state.set(initialPolizaSeguroState); }
}
