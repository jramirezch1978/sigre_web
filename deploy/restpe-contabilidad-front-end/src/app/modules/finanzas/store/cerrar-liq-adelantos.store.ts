import { Injectable, signal, computed } from '@angular/core';
import { CerrarLiqAdelantosEntity } from '../domain/models/cerrar-liq-adelantos.entity';
import { CerrarLiqAdelantosState, initialCerrarLiqAdelantosState } from './cerrar-liq-adelantos.state';

@Injectable()
export class CerrarLiqAdelantosStore {
  private readonly _state = signal<CerrarLiqAdelantosState>(initialCerrarLiqAdelantosState);

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
  setLiquidaciones(data: CerrarLiqAdelantosEntity[]) {
    this._state.update(s => ({ ...s, liquidaciones: data }));
  }

  updateLiquidacion(entity: CerrarLiqAdelantosEntity) {
    this._state.update(s => ({
      ...s,
      liquidaciones: s.liquidaciones.map(l =>
        l.cla_num_liquidacion === entity.cla_num_liquidacion ? entity : l
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
    this._state.set(initialCerrarLiqAdelantosState);
  }
}
