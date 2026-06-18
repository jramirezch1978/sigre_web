import { Injectable, computed, signal } from '@angular/core';
import { RegistroOperacionActivoState, initialRegistroOperacionActivoState } from './registro-operacion-activo.state';
import { RegistroOperacionActivoEntity } from '../domain/models/registro-operacion-activo.entity';

@Injectable()
export class RegistroOperacionActivoStore {
  private readonly _state = signal<RegistroOperacionActivoState>(initialRegistroOperacionActivoState);

  // ── Selectores ──────────────────────────────────────────────────────────────
  readonly registros      = computed(() => this._state().registros);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly isLoading      = computed(() => this._state().loadingObtener);
  readonly errorObtener   = computed(() => this._state().errorObtener);

  // ── Setters ─────────────────────────────────────────────────────────────────
  setRegistros(items: RegistroOperacionActivoEntity[]) { this._state.update(s => ({ ...s, registros: items })); }
  setLoadingObtener(v: boolean)                        { this._state.update(s => ({ ...s, loadingObtener: v })); }
  setErrorObtener(e: string | null)                    { this._state.update(s => ({ ...s, errorObtener: e })); }

  reset() { this._state.set(initialRegistroOperacionActivoState); }
}
