import { Injectable, signal, computed } from '@angular/core';
import { CarterasCobrosEntity } from '../domain/models/carteras-cobros.entity';
import { CarterasCobrosState, initialCarterasCobrosState } from './carteras-cobros.state';

@Injectable()
export class CarterasCobrosStore {
  private readonly _state = signal<CarterasCobrosState>(initialCarterasCobrosState);

  // ── Selectores ────────────────────────────────────────────────────────────
  readonly cobros = computed(() => this._state().cobros);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly loadingActualizar = computed(() => this._state().loadingActualizar);
  readonly isLoading = computed(
    () => this._state().loadingObtener || this._state().loadingActualizar
  );
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly errorActualizar = computed(() => this._state().errorActualizar);
  readonly actualizadoOk = computed(() => this._state().actualizadoOk);

  // ── Mutadores ─────────────────────────────────────────────────────────────
  setCobros(data: CarterasCobrosEntity[]) {
    this._state.update(s => ({ ...s, cobros: data }));
  }

  updateCobro(entity: CarterasCobrosEntity) {
    this._state.update(s => ({
      ...s,
      cobros: s.cobros.map(c => c.cc_serieNum === entity.cc_serieNum ? entity : c),
    }));
  }

  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }

  setLoadingActualizar(v: boolean) {
    this._state.update(s => ({ ...s, loadingActualizar: v }));
  }

  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }

  setErrorActualizar(e: string | null) {
    this._state.update(s => ({ ...s, errorActualizar: e }));
  }

  setActualizadoOk(v: boolean) {
    this._state.update(s => ({ ...s, actualizadoOk: v }));
  }

  reset() {
    this._state.set(initialCarterasCobrosState);
  }
}
