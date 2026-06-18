import { Injectable, signal, computed } from '@angular/core';
import { OrdenGiroEntity } from '../domain/models/orden-giro.entity';
import { OrdenGiroState, initialOrdenGiroState } from './orden-giro.state';

@Injectable()
export class OrdenGiroStore {
  private readonly _state = signal<OrdenGiroState>(initialOrdenGiroState);

  // ── Selectores ────────────────────────────────────────────────────────────
  readonly ordenes = computed(() => this._state().ordenes);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly loadingGuardar = computed(() => this._state().loadingGuardar);
  readonly loadingActualizar = computed(() => this._state().loadingActualizar);
  readonly isLoading = computed(
    () => this._state().loadingObtener || this._state().loadingGuardar || this._state().loadingActualizar
  );
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly errorGuardar = computed(() => this._state().errorGuardar);
  readonly errorActualizar = computed(() => this._state().errorActualizar);
  readonly guardadoOk = computed(() => this._state().guardadoOk);
  readonly actualizadoOk = computed(() => this._state().actualizadoOk);

  // ── Mutadores ─────────────────────────────────────────────────────────────
  setOrdenes(data: OrdenGiroEntity[]) {
    this._state.update(s => ({ ...s, ordenes: data }));
  }

  addOrden(entity: OrdenGiroEntity) {
    this._state.update(s => ({ ...s, ordenes: [...s.ordenes, entity] }));
  }

  updateOrden(entity: OrdenGiroEntity) {
    this._state.update(s => ({
      ...s,
      ordenes: s.ordenes.map(o =>
        o.og_num_orden_giro === entity.og_num_orden_giro ? entity : o
      ),
    }));
  }

  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }
  setLoadingGuardar(v: boolean) {
    this._state.update(s => ({ ...s, loadingGuardar: v }));
  }
  setLoadingActualizar(v: boolean) {
    this._state.update(s => ({ ...s, loadingActualizar: v }));
  }
  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }
  setErrorGuardar(e: string | null) {
    this._state.update(s => ({ ...s, errorGuardar: e }));
  }
  setErrorActualizar(e: string | null) {
    this._state.update(s => ({ ...s, errorActualizar: e }));
  }
  setGuardadoOk(v: boolean) {
    this._state.update(s => ({ ...s, guardadoOk: v }));
  }
  setActualizadoOk(v: boolean) {
    this._state.update(s => ({ ...s, actualizadoOk: v }));
  }
  reset() {
    this._state.set(initialOrdenGiroState);
  }
}
