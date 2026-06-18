import { Injectable, signal, computed } from '@angular/core';
import { ConciliacionState, initialConciliacionState } from './conciliacion.state';
import { ConciliacionEntity } from '../domain/models/conciliacion.entity';

@Injectable()
export class ConciliacionStore {
  private readonly _state = signal<ConciliacionState>(initialConciliacionState);

  readonly conciliaciones = computed(() => this._state().conciliaciones);
  readonly isLoading = computed(() => this._state().isLoading);
  readonly error = computed(() => this._state().error);

  setLoading(isLoading: boolean): void {
    this._state.update(state => ({ ...state, isLoading }));
  }

  setConciliaciones(conciliaciones: ConciliacionEntity[]): void {
    this._state.update(state => ({ ...state, conciliaciones, isLoading: false }));
  }

  setError(error: string): void {
    this._state.update(state => ({ ...state, error, isLoading: false }));
  }

  resetState(): void {
    this._state.set(initialConciliacionState);
  }
}
