import { Injectable, signal, computed } from '@angular/core';
import { LiqRendicionEntity } from '../domain/models/liq-rendicion.entity';
import { AprobarLiqGastosState, initialAprobarLiqGastosState } from './aprobar-liq-gastos.state';

@Injectable()
export class AprobarLiqGastosStore {
  private readonly _state = signal<AprobarLiqGastosState>(initialAprobarLiqGastosState);

  // ── Selectores ────────────────────────────────────────────────────────────
  readonly liquidaciones = computed(() => this._state().liquidaciones);
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
  setLiquidaciones(data: LiqRendicionEntity[]) {
    this._state.update(s => ({ ...s, liquidaciones: data }));
  }

  updateLiquidacion(entity: LiqRendicionEntity) {
    this._state.update(s => ({
      ...s,
      liquidaciones: s.liquidaciones.map(l =>
        l.lr_num_liquidacion === entity.lr_num_liquidacion ? entity : l
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
    this._state.set(initialAprobarLiqGastosState);
  }
}
