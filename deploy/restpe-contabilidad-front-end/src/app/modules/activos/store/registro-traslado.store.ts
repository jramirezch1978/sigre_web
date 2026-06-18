import { Injectable, computed, signal } from '@angular/core';
import { RegistroTrasladoState, initialRegistroTrasladoState } from './registro-traslado.state';
import { RegistroTrasladoEntity } from '../domain/models/registro-traslado.entity';

@Injectable()
export class RegistroTrasladoStore {
  private readonly _state = signal<RegistroTrasladoState>(initialRegistroTrasladoState);

  // ── Selectores ──────────────────────────────────────────────────────────────
  readonly traslados      = computed(() => this._state().traslados);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly isLoading      = computed(() => this._state().loadingObtener);
  readonly errorObtener   = computed(() => this._state().errorObtener);

  // ── Setters ─────────────────────────────────────────────────────────────────
  setTraslados(items: RegistroTrasladoEntity[]) { this._state.update(s => ({ ...s, traslados: items })); }
  setLoadingObtener(v: boolean)                 { this._state.update(s => ({ ...s, loadingObtener: v })); }
  setErrorObtener(e: string | null)             { this._state.update(s => ({ ...s, errorObtener: e })); }

  reset() { this._state.set(initialRegistroTrasladoState); }
}
