import { Injectable, signal, computed } from '@angular/core';
import { CuentaPagarState, initialCuentaPagarState } from './cuenta-pagar.state';
import { CuentaPagarEntity } from '../domain/models/cuenta-pagar.entity';

@Injectable()
export class CuentaPagarStore {
  private readonly _state = signal<CuentaPagarState>(initialCuentaPagarState);

  readonly facturas = computed(() => this._state().facturas);
  readonly isLoading = computed(() => this._state().isLoading);
  readonly error = computed(() => this._state().error);

  setLoading(isLoading: boolean): void {
    this._state.update(state => ({ ...state, isLoading }));
  }

  setFacturas(facturas: CuentaPagarEntity[]): void {
    this._state.update(state => ({ ...state, facturas, isLoading: false }));
  }

  setError(error: string): void {
    this._state.update(state => ({ ...state, error, isLoading: false }));
  }

  resetState(): void {
    this._state.set(initialCuentaPagarState);
  }
}
