import { Injectable, computed, signal } from '@angular/core';
import { CompraPorCategoriaEntity } from '../domain/models/compra-por-categoria.entity';

interface ReporteComprasCategoriaState {
  registros: CompraPorCategoriaEntity[];
  loading:   boolean;
  error:     string | null;
}

const INITIAL_STATE: ReporteComprasCategoriaState = {
  registros: [],
  loading:   false,
  error:     null
};

/**
 * Store reactivo (Angular Signals) del Reporte de Compras por Categoría.
 * Fuente única de verdad para el componente.
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasCategoriaStore {

  private readonly _state = signal<ReporteComprasCategoriaState>(INITIAL_STATE);

  // Selectores
  readonly registros = computed(() => this._state().registros);
  readonly loading   = computed(() => this._state().loading);
  readonly error     = computed(() => this._state().error);

  // Mutadores
  setLoading(loading: boolean): void {
    this._state.update(s => ({ ...s, loading }));
  }

  setRegistros(registros: CompraPorCategoriaEntity[]): void {
    this._state.update(s => ({ ...s, registros, loading: false, error: null }));
  }

  setError(error: string): void {
    this._state.update(s => ({ ...s, error, loading: false }));
  }

  resetState(): void {
    this._state.set(INITIAL_STATE);
  }
}
