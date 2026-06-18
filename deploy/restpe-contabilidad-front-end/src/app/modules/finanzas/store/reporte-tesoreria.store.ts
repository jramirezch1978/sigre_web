import { Injectable, signal, computed } from '@angular/core';
import { ReporteTesoreriaState, initialReporteTesoreriaState } from './reporte-tesoreria.state';
import { ReporteTesoreriaEntity } from '../domain/models/reporte-tesoreria.entity';

@Injectable()
export class ReporteTesoreriaStore {
  private readonly _state = signal<ReporteTesoreriaState>(initialReporteTesoreriaState);

  readonly movimientos = computed(() => this._state().movimientos);
  readonly isLoading = computed(() => this._state().isLoading);
  readonly error = computed(() => this._state().error);

  setLoading(isLoading: boolean): void {
    this._state.update(state => ({ ...state, isLoading }));
  }

  setMovimientos(movimientos: ReporteTesoreriaEntity[]): void {
    this._state.update(state => ({ ...state, movimientos, isLoading: false }));
  }

  setError(error: string): void {
    this._state.update(state => ({ ...state, error, isLoading: false }));
  }

  resetState(): void {
    this._state.set(initialReporteTesoreriaState);
  }
}
