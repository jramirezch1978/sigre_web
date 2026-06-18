import { Injectable, signal, computed } from '@angular/core';
import { PagoRecibidoEntity } from '../domain/models/pago-recibido.entity';
import { PagoRecibidoState, initialPagoRecibidoState } from './pago-recibido.state';

@Injectable()
export class PagoRecibidoStore {
  private readonly _state = signal<PagoRecibidoState>(initialPagoRecibidoState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly pagos = computed(() => this._state().pagos);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly isLoading = computed(() => this._state().loadingObtener);

  // ── Mutadores ────────────────────────────────────────────────────────────
  setPagos(pagos: PagoRecibidoEntity[]) {
    this._state.update(s => ({ ...s, pagos }));
  }
  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }
  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }
  reset() {
    this._state.set(initialPagoRecibidoState);
  }
}
