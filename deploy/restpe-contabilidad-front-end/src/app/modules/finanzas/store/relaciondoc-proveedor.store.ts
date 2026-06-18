import { Injectable, signal, computed } from '@angular/core';
import { RelacionDocProveedorMap } from '../domain/models/relaciondoc-proveedor.entity';
import {
  RelacionDocProveedorState,
  initialRelacionDocProveedorState,
} from './relaciondoc-proveedor.state';

@Injectable()
export class RelacionDocProveedorStore {
  private readonly _state = signal<RelacionDocProveedorState>(initialRelacionDocProveedorState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly facturasPorProveedor = computed(() => this._state().facturasPorProveedor);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly isLoading = computed(() => this._state().loadingObtener);

  // ── Mutadores ────────────────────────────────────────────────────────────
  setFacturasPorProveedor(data: RelacionDocProveedorMap) {
    this._state.update(s => ({ ...s, facturasPorProveedor: data }));
  }
  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }
  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }
  reset() {
    this._state.set(initialRelacionDocProveedorState);
  }
}
