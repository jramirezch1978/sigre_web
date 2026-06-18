import { Injectable, signal, computed } from '@angular/core';
import { ReporteFinanzasState, initialReporteFinanzasState } from './reporte-finanzas.state';
import { ReporteFinanzasEntity } from '../domain/models/reporte-finanzas.entity';

@Injectable()
export class ReporteFinanzasStore {
  private readonly _state = signal<ReporteFinanzasState>(initialReporteFinanzasState);

  readonly movimientos = computed(() => this._state().movimientos);
  readonly isLoading = computed(() => this._state().isLoading);
  readonly error = computed(() => this._state().error);

  setLoading(isLoading: boolean): void {
    this._state.update(state => ({ ...state, isLoading }));
  }

  setMovimientos(movimientos: ReporteFinanzasEntity[]): void {
    this._state.update(state => ({ ...state, movimientos, isLoading: false }));
  }

  setError(error: string): void {
    this._state.update(state => ({ ...state, error, isLoading: false }));
  }

  resetState(): void {
    this._state.set(initialReporteFinanzasState);
  }
}
