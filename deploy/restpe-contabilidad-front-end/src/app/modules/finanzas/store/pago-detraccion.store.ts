import { Injectable, signal, computed } from '@angular/core';
import { PagoDetraccionEntity } from '../domain/models/pago-detraccion.entity';
import { PagoDetraccionState, initialPagoDetraccionState } from './pago-detraccion.state';

@Injectable()
export class PagoDetraccionStore {
  private readonly _state = signal<PagoDetraccionState>(initialPagoDetraccionState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly detracciones = computed(() => this._state().detracciones);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly isLoading = computed(() => this._state().loadingObtener);

  // ── Mutadores ────────────────────────────────────────────────────────────
  setDetracciones(detracciones: PagoDetraccionEntity[]) {
    this._state.update(s => ({ ...s, detracciones }));
  }

  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }

  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }

  reset() {
    this._state.set(initialPagoDetraccionState);
  }
}
