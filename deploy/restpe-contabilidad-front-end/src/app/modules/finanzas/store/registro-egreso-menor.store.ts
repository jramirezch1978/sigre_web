import { Injectable, signal, computed } from '@angular/core';
import { RegistroEgresoMenorEntity } from '../domain/models/registro-egreso-menor.entity';
import { RegistroEgresoMenorState, initialRegistroEgresoMenorState } from './registro-egreso-menor.state';

@Injectable()
export class RegistroEgresoMenorStore {
  private readonly _state = signal<RegistroEgresoMenorState>(initialRegistroEgresoMenorState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly movimientos = computed(() => this._state().movimientos);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly isLoading = computed(() => this._state().loadingObtener);

  // ── Mutadores ────────────────────────────────────────────────────────────
  setMovimientos(movimientos: RegistroEgresoMenorEntity[]) {
    this._state.update(s => ({ ...s, movimientos }));
  }

  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }

  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }

  reset() {
    this._state.set(initialRegistroEgresoMenorState);
  }
}
