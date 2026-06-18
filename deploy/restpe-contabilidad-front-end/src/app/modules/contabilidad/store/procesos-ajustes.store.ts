import { Injectable, computed, signal } from '@angular/core';
import { ProcesosAjustesState, PROCESOS_AJUSTES_INITIAL_STATE } from './procesos-ajustes.state';
import { ProcesosAjustesEntity, ProcesosAjusteItem } from '../domain/models/procesos-ajustes.entity';

/**
 * ProcesosAjustesStore — Store reactivo basado en signals.
 * Almacena el estado del listado de asientos de procesos de ajuste contable.
 */
@Injectable()
export class ProcesosAjustesStore {

  private readonly _state = signal<ProcesosAjustesState>(PROCESOS_AJUSTES_INITIAL_STATE);

  // Selectors
  readonly data         = computed(() => this._state().data);
  readonly items        = computed<ProcesosAjusteItem[]>(() => this._state().data?.items ?? []);
  readonly isLoading    = computed(() => this._state().isLoading);
  readonly errorObtener = computed(() => this._state().errorObtener);

  // Mutators
  setLoading(isLoading: boolean): void {
    this._state.update(s => ({ ...s, isLoading }));
  }

  setData(data: ProcesosAjustesEntity): void {
    this._state.update(s => ({ ...s, data, isLoading: false, errorObtener: null }));
  }

  setError(errorObtener: string): void {
    this._state.update(s => ({ ...s, errorObtener, isLoading: false }));
  }

  setErrorObtener(errorObtener: string | null): void {
    this._state.update(s => ({ ...s, errorObtener }));
  }

  reset(): void {
    this._state.set(PROCESOS_AJUSTES_INITIAL_STATE);
  }
}
