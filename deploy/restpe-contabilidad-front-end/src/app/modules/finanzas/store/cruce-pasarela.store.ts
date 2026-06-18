import { Injectable, signal, computed } from '@angular/core';
import { CrucePasarelaState, initialCrucePasarelaState } from './cruce-pasarela.state';
import { CrucePasarelaEntity } from '../domain/models/cruce-pasarela.entity';
import { MovimientoPasarelaEntity } from '../domain/models/movimiento-pasarela.entity';

@Injectable()
export class CrucePasarelaStore {
  private readonly _state = signal<CrucePasarelaState>(initialCrucePasarelaState);

  readonly cruces = computed(() => this._state().cruces);
  readonly movimientos = computed(() => this._state().movimientos);
  readonly isLoading = computed(() => this._state().isLoading);
  readonly error = computed(() => this._state().error);

  setLoading(isLoading: boolean): void {
    this._state.update(state => ({ ...state, isLoading }));
  }

  setCruces(cruces: CrucePasarelaEntity[]): void {
    this._state.update(state => ({ ...state, cruces, isLoading: false }));
  }

  setMovimientos(movimientos: MovimientoPasarelaEntity[]): void {
    this._state.update(state => ({ ...state, movimientos, isLoading: false }));
  }

  setError(error: string): void {
    this._state.update(state => ({ ...state, error, isLoading: false }));
  }

  resetState(): void {
    this._state.set(initialCrucePasarelaState);
  }
}
