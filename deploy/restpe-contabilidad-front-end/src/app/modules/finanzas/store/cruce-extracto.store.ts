import { Injectable, signal, computed } from '@angular/core';
import { CruceExtractoState, initialCruceExtractoState } from './cruce-extracto.state';
import { CruceExtractoEntity } from '../domain/models/cruce-extracto.entity';
import { MovimientoCruceEntity } from '../domain/models/movimiento-cruce.entity';

@Injectable()
export class CruceExtractoStore {
  private readonly _state = signal<CruceExtractoState>(initialCruceExtractoState);

  readonly cruces = computed(() => this._state().cruces);
  readonly movimientos = computed(() => this._state().movimientos);
  readonly isLoading = computed(() => this._state().isLoading);
  readonly error = computed(() => this._state().error);

  setLoading(isLoading: boolean): void {
    this._state.update(state => ({ ...state, isLoading }));
  }

  setCruces(cruces: CruceExtractoEntity[]): void {
    this._state.update(state => ({ ...state, cruces, isLoading: false }));
  }

  setMovimientos(movimientos: MovimientoCruceEntity[]): void {
    this._state.update(state => ({ ...state, movimientos, isLoading: false }));
  }

  setError(error: string): void {
    this._state.update(state => ({ ...state, error, isLoading: false }));
  }

  resetState(): void {
    this._state.set(initialCruceExtractoState);
  }
}
