import { Injectable, signal, computed } from '@angular/core';
import { LetraCambioEntity } from '../domain/models/letra-cambio.entity';
import { LetraCambioState, LETRA_CAMBIO_INITIAL_STATE } from './letra-cambio.state';

@Injectable()
export class LetraCambioStore {
  private readonly _state = signal<LetraCambioState>(LETRA_CAMBIO_INITIAL_STATE);

  // ── Selectores ─────────────────────────────────────────────────────────────
  readonly letras = computed(() => this._state().letras);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly loadingGuardar = computed(() => this._state().loadingGuardar);
  readonly errorGuardar = computed(() => this._state().errorGuardar);
  readonly loadingActualizar = computed(() => this._state().loadingActualizar);
  readonly errorActualizar = computed(() => this._state().errorActualizar);

  readonly isLoading = computed(() =>
    this._state().loadingObtener ||
    this._state().loadingGuardar ||
    this._state().loadingActualizar
  );

  // ── Mutaciones ─────────────────────────────────────────────────────────────
  setLetras(letras: LetraCambioEntity[]): void {
    this._state.update(s => ({ ...s, letras, loadingObtener: false, errorObtener: null }));
  }

  setLoadingObtener(value: boolean): void {
    this._state.update(s => ({ ...s, loadingObtener: value }));
  }

  setErrorObtener(error: string | null): void {
    this._state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  setLoadingGuardar(value: boolean): void {
    this._state.update(s => ({ ...s, loadingGuardar: value }));
  }

  setErrorGuardar(error: string | null): void {
    this._state.update(s => ({ ...s, errorGuardar: error, loadingGuardar: false }));
  }

  addLetra(letra: LetraCambioEntity): void {
    this._state.update(s => ({
      ...s,
      letras: [letra, ...s.letras],
      loadingGuardar: false,
      errorGuardar: null,
    }));
  }

  setLoadingActualizar(value: boolean): void {
    this._state.update(s => ({ ...s, loadingActualizar: value }));
  }

  setErrorActualizar(error: string | null): void {
    this._state.update(s => ({ ...s, errorActualizar: error, loadingActualizar: false }));
  }

  updateLetra(letra: LetraCambioEntity): void {
    this._state.update(s => ({
      ...s,
      letras: s.letras.map(l => l.letra_codigo === letra.letra_codigo ? letra : l),
      loadingActualizar: false,
      errorActualizar: null,
    }));
  }

  reset(): void {
    this._state.set(LETRA_CAMBIO_INITIAL_STATE);
  }
}
