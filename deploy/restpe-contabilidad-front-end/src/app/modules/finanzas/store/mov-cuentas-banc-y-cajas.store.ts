import { Injectable, signal, computed } from '@angular/core';
import { MovCuentasBancYCajasEntity } from '../domain/models/mov-cuentas-banc-y-cajas.entity';
import { MovCuentasBancYCajasState, initialMovCuentasBancYCajasState } from './mov-cuentas-banc-y-cajas.state';

@Injectable()
export class MovCuentasBancYCajasStore {
  private readonly _state = signal<MovCuentasBancYCajasState>(initialMovCuentasBancYCajasState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly movimientos = computed(() => this._state().movimientos);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly isLoading = computed(() => this._state().loadingObtener);

  // ── Mutadores ────────────────────────────────────────────────────────────
  setMovimientos(movimientos: MovCuentasBancYCajasEntity[]) {
    this._state.update(s => ({ ...s, movimientos }));
  }

  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }

  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }

  reset() {
    this._state.set(initialMovCuentasBancYCajasState);
  }
}
