import { Injectable, signal, computed } from '@angular/core';
import { ObligacionVencerState, initialObligacionVencerState } from './obligacion-vencer.state';
import { ObligacionVencerEntity } from '../domain/models/obligacion-vencer.entity';

@Injectable()
export class ObligacionVencerStore {
  private readonly _state = signal<ObligacionVencerState>(initialObligacionVencerState);

  readonly obligaciones = computed(() => this._state().obligaciones);
  readonly isLoading = computed(() => this._state().isLoading);
  readonly error = computed(() => this._state().error);

  setLoading(isLoading: boolean): void {
    this._state.update(state => ({ ...state, isLoading }));
  }

  setObligaciones(obligaciones: ObligacionVencerEntity[]): void {
    this._state.update(state => ({ ...state, obligaciones, isLoading: false }));
  }

  setError(error: string): void {
    this._state.update(state => ({ ...state, error, isLoading: false }));
  }

  resetState(): void {
    this._state.set(initialObligacionVencerState);
  }
}
