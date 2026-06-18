import { Injectable, signal, computed } from '@angular/core';
import { RegistroIngresoDeDiaState, initialRegistroIngresoDeDiaState } from './registro-ingreso-de-dia.state';
import { RegistroIngresoDeDiaEntity } from '../domain/models/registro-ingreso-de-dia.entity';

@Injectable()
export class RegistroIngresoDeDiaStore {
  private readonly _state = signal<RegistroIngresoDeDiaState>(initialRegistroIngresoDeDiaState);

  readonly ingresos = computed(() => this._state().ingresos);
  readonly isLoading = computed(() => this._state().isLoading);
  readonly error = computed(() => this._state().error);

  setLoading(isLoading: boolean): void {
    this._state.update(state => ({ ...state, isLoading }));
  }

  setIngresos(ingresos: RegistroIngresoDeDiaEntity[]): void {
    this._state.update(state => ({ ...state, ingresos, isLoading: false }));
  }

  setError(error: string): void {
    this._state.update(state => ({ ...state, error, isLoading: false }));
  }

  resetState(): void {
    this._state.set(initialRegistroIngresoDeDiaState);
  }
}
