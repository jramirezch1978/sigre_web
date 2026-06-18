import { Injectable, computed, signal } from '@angular/core';
import { RecepcionTrasladoState, initialRecepcionTrasladoState } from './recepcion-traslado.state';
import { RecepcionTrasladoEntity } from '../domain/models/recepcion-traslado.entity';

@Injectable()
export class RecepcionTrasladoStore {
  private readonly _state = signal<RecepcionTrasladoState>(initialRecepcionTrasladoState);

  // ── Selectores ──────────────────────────────────────────────────────────────
  readonly traslados      = computed(() => this._state().traslados);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly isLoading      = computed(() => this._state().loadingObtener);
  readonly errorObtener   = computed(() => this._state().errorObtener);

  // ── Setters ─────────────────────────────────────────────────────────────────
  setTraslados(items: RecepcionTrasladoEntity[]) { this._state.update(s => ({ ...s, traslados: items })); }
  setLoadingObtener(v: boolean)                  { this._state.update(s => ({ ...s, loadingObtener: v })); }
  setErrorObtener(e: string | null)              { this._state.update(s => ({ ...s, errorObtener: e })); }

  reset() { this._state.set(initialRecepcionTrasladoState); }
}
