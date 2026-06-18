import { Injectable, computed, signal } from '@angular/core';
import { CanjeReprogramacionEntity } from '../domain/models/canje-reprogramacion.entity';
import { CanjeReprogramacionState, CANJE_REPROGRAMACION_INITIAL_STATE } from './canje-reprogramacion.state';

@Injectable()
export class CanjeReprogramacionStore {
  private readonly _state = signal<CanjeReprogramacionState>(CANJE_REPROGRAMACION_INITIAL_STATE);

  // Selectores
  readonly registros = computed(() => this._state().registros);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly loadingCanje = computed(() => this._state().loadingCanje);
  readonly loadingReprogramar = computed(() => this._state().loadingReprogramar);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly errorCanje = computed(() => this._state().errorCanje);
  readonly errorReprogramar = computed(() => this._state().errorReprogramar);
  readonly resultCanje = computed(() => this._state().resultCanje);
  readonly resultReprogramar = computed(() => this._state().resultReprogramar);

  readonly isLoading = computed(() =>
    this._state().loadingObtener ||
    this._state().loadingCanje ||
    this._state().loadingReprogramar
  );
  readonly hasError = computed(() =>
    !!this._state().errorObtener ||
    !!this._state().errorCanje ||
    !!this._state().errorReprogramar
  );

  // Mutadores — Obtener
  setLoadingObtener(loading: boolean): void {
    this._state.update(s => ({ ...s, loadingObtener: loading }));
  }
  setRegistros(registros: CanjeReprogramacionEntity[]): void {
    this._state.update(s => ({ ...s, registros, loadingObtener: false }));
  }
  setErrorObtener(error: string | null): void {
    this._state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  // Mutadores — Canje
  setLoadingCanje(loading: boolean): void {
    this._state.update(s => ({ ...s, loadingCanje: loading }));
  }
  setResultCanje(result: { success: boolean } | null): void {
    this._state.update(s => ({ ...s, resultCanje: result, loadingCanje: false }));
  }
  setErrorCanje(error: string | null): void {
    this._state.update(s => ({ ...s, errorCanje: error, loadingCanje: false }));
  }

  // Mutadores — Reprogramar
  setLoadingReprogramar(loading: boolean): void {
    this._state.update(s => ({ ...s, loadingReprogramar: loading }));
  }
  setResultReprogramar(result: { success: boolean } | null): void {
    this._state.update(s => ({ ...s, resultReprogramar: result, loadingReprogramar: false }));
  }
  setErrorReprogramar(error: string | null): void {
    this._state.update(s => ({ ...s, errorReprogramar: error, loadingReprogramar: false }));
  }

  resetState(): void {
    this._state.set(CANJE_REPROGRAMACION_INITIAL_STATE);
  }
}
