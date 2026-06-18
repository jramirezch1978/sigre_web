import { Injectable, computed, signal } from '@angular/core';
import { RevaluacionState, initialRevaluacionState } from './revaluacion.state';
import { RevaluacionEntity } from '../domain/models/revaluacion.entity';

@Injectable()
export class RevaluacionStore {
  private readonly _state = signal<RevaluacionState>(initialRevaluacionState);

  // ── Selectores ──────────────────────────────────────────────────────────────
  readonly revaluaciones  = computed(() => this._state().revaluaciones);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly isLoading      = computed(() => this._state().loadingObtener);
  readonly errorObtener   = computed(() => this._state().errorObtener);

  // ── Setters ─────────────────────────────────────────────────────────────────
  setRevaluaciones(items: RevaluacionEntity[]) { this._state.update(s => ({ ...s, revaluaciones: items })); }
  setLoadingObtener(v: boolean)                { this._state.update(s => ({ ...s, loadingObtener: v })); }
  setErrorObtener(e: string | null)            { this._state.update(s => ({ ...s, errorObtener: e })); }

  reset() { this._state.set(initialRevaluacionState); }
}
