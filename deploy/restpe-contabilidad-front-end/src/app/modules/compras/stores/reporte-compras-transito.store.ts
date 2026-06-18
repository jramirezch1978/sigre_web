import { Injectable, signal, computed } from '@angular/core';
import { CompraTransitoEntity } from '../domain/models/compra-transito.entity';

export interface ReporteComprasTransitoState {
  registros: CompraTransitoEntity[];
  loading: boolean;
  error: string | null;
}

const initialState: ReporteComprasTransitoState = {
  registros: [],
  loading: false,
  error: null,
};

/**
 * Store de señales para el reporte de Compras en Tránsito
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasTransitoStore {
  private readonly _state = signal<ReporteComprasTransitoState>(initialState);

  // Selectores
  readonly registros = computed(() => this._state().registros);
  readonly loading   = computed(() => this._state().loading);
  readonly error     = computed(() => this._state().error);

  setLoading(loading: boolean): void {
    this._state.update(s => ({ ...s, loading }));
  }

  setRegistros(registros: CompraTransitoEntity[]): void {
    this._state.update(s => ({ ...s, registros }));
  }

  setError(error: string | null): void {
    this._state.update(s => ({ ...s, error }));
  }

  resetState(): void {
    this._state.set(initialState);
  }
}
