import { Injectable, signal, computed } from '@angular/core';
import { AnulacionPagosEntity } from '../domain/models/anulacion-pagos.entity';
import { AnulacionPagosState, initialAnulacionPagosState } from './anulacion-pagos.state';

@Injectable()
export class AnulacionPagosStore {
  private readonly _state = signal<AnulacionPagosState>(initialAnulacionPagosState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly registros = computed(() => this._state().registros);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly isLoading = computed(() => this._state().loadingObtener);

  // ── Mutadores ────────────────────────────────────────────────────────────
  setRegistros(registros: AnulacionPagosEntity[]) {
    this._state.update(s => ({ ...s, registros }));
  }

  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }

  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }

  reset() {
    this._state.set(initialAnulacionPagosState);
  }
}
