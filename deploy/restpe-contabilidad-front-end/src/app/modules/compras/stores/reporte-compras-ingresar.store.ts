import { Injectable, signal, computed } from '@angular/core';
import { CompraPorIngresarEntity } from '../domain/models/compra-por-ingresar.entity';

export interface ReporteComprasIngresarState {
  registros: CompraPorIngresarEntity[];
  loading: boolean;
  error: string | null;
}

const initialState: ReporteComprasIngresarState = {
  registros: [],
  loading: false,
  error: null,
};

/**
 * Store de señales para el reporte de Compras por Ingresar
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasIngresarStore {
  private readonly _state = signal<ReporteComprasIngresarState>(initialState);

  // Selectores
  readonly registros = computed(() => this._state().registros);
  readonly loading   = computed(() => this._state().loading);
  readonly error     = computed(() => this._state().error);

  setLoading(loading: boolean): void {
    this._state.update(s => ({ ...s, loading }));
  }

  setRegistros(registros: CompraPorIngresarEntity[]): void {
    this._state.update(s => ({ ...s, registros }));
  }

  setError(error: string | null): void {
    this._state.update(s => ({ ...s, error }));
  }

  resetState(): void {
    this._state.set(initialState);
  }
}
