import { Injectable, signal, computed } from '@angular/core';
import { AprobarGiroEntity } from '../domain/models/aprobar-giro.entity';
import { AprobarGiroState, initialAprobarGiroState } from './aprobar-giro.state';

@Injectable()
export class AprobarGiroStore {
  private readonly _state = signal<AprobarGiroState>(initialAprobarGiroState);

  // ── Selectores ────────────────────────────────────────────────────────────
  readonly ordenes = computed(() => this._state().ordenes);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly loadingActualizar = computed(() => this._state().loadingActualizar);
  readonly isLoading = computed(
    () => this._state().loadingObtener || this._state().loadingActualizar
  );
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly errorActualizar = computed(() => this._state().errorActualizar);
  readonly actualizadoOk = computed(() => this._state().actualizadoOk);
  readonly mensajeExito = computed(() => this._state().mensajeExito);

  // ── Mutadores ─────────────────────────────────────────────────────────────
  setOrdenes(data: AprobarGiroEntity[]) {
    this._state.update(s => ({ ...s, ordenes: data }));
  }

  updateOrden(entity: AprobarGiroEntity) {
    this._state.update(s => ({
      ...s,
      ordenes: s.ordenes.map(o =>
        o.ag_num_orden_giro === entity.ag_num_orden_giro ? entity : o
      ),
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

  setMensajeExito(msg: string | null) {
    this._state.update(s => ({ ...s, mensajeExito: msg }));
  }

  reset() {
    this._state.set(initialAprobarGiroState);
  }
}
