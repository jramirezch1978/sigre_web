import { Injectable, signal, computed } from '@angular/core';
import { RelacionDocClienteMap } from '../domain/models/relaciondoc-cliente.entity';
import {
  RelacionDocClienteState,
  initialRelacionDocClienteState,
} from './relaciondoc-cliente.state';

@Injectable()
export class RelacionDocClienteStore {
  private readonly _state = signal<RelacionDocClienteState>(initialRelacionDocClienteState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly facturasPorCliente = computed(() => this._state().facturasPorCliente);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly isLoading = computed(() => this._state().loadingObtener);

  // ── Mutadores ────────────────────────────────────────────────────────────
  setFacturasPorCliente(data: RelacionDocClienteMap) {
    this._state.update(s => ({ ...s, facturasPorCliente: data }));
  }
  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }
  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }
  reset() {
    this._state.set(initialRelacionDocClienteState);
  }
}
