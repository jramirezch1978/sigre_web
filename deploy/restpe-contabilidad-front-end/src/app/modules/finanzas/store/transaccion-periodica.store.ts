import { Injectable, signal, computed } from '@angular/core';
import { TransaccionPeriodicaEntity } from '../domain/models/transaccion-periodica.entity';
import {
  TransaccionPeriodicaState,
  initialTransaccionPeriodicaState,
} from './transaccion-periodica.state';

@Injectable()
export class TransaccionPeriodicaStore {
  private readonly _state = signal<TransaccionPeriodicaState>(initialTransaccionPeriodicaState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly transacciones = computed(() => this._state().transacciones);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly loadingGuardar = computed(() => this._state().loadingGuardar);
  readonly loadingActualizar = computed(() => this._state().loadingActualizar);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly errorGuardar = computed(() => this._state().errorGuardar);
  readonly errorActualizar = computed(() => this._state().errorActualizar);
  readonly resultGuardar = computed(() => this._state().resultGuardar);
  readonly resultActualizar = computed(() => this._state().resultActualizar);

  readonly isLoading = computed(
    () =>
      this._state().loadingObtener ||
      this._state().loadingGuardar ||
      this._state().loadingActualizar
  );
  readonly hasError = computed(
    () =>
      !!this._state().errorObtener ||
      !!this._state().errorGuardar ||
      !!this._state().errorActualizar
  );

  // ── Mutadores ────────────────────────────────────────────────────────────
  setTransacciones(transacciones: TransaccionPeriodicaEntity[]) {
    this._state.update(s => ({ ...s, transacciones }));
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
  setResultGuardar(r: { success: boolean } | null) {
    this._state.update(s => ({ ...s, resultGuardar: r }));
  }
  setResultActualizar(r: { success: boolean } | null) {
    this._state.update(s => ({ ...s, resultActualizar: r }));
  }
  addTransaccion(transaccion: TransaccionPeriodicaEntity) {
    this._state.update(s => ({ ...s, transacciones: [transaccion, ...s.transacciones] }));
  }
  updateTransaccion(codigo: string, cambios: Partial<TransaccionPeriodicaEntity>) {
    this._state.update(s => ({
      ...s,
      transacciones: s.transacciones.map(t =>
        t.transaccion_codigo_programacion === codigo ? { ...t, ...cambios } : t
      ),
    }));
  }
  reset() {
    this._state.set(initialTransaccionPeriodicaState);
  }
}
