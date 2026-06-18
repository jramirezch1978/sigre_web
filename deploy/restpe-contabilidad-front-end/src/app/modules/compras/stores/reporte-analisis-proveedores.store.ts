import { Injectable, computed, signal } from '@angular/core';
import { AnalisisProveedorEntity } from '../domain/models/analisis-proveedor.entity';

interface ReporteAnalisisProveedoresState {
  registros: AnalisisProveedorEntity[];
  loading:   boolean;
  error:     string | null;
}

const INITIAL_STATE: ReporteAnalisisProveedoresState = {
  registros: [],
  loading:   false,
  error:     null
};

/**
 * Store reactivo (Angular Signals) del Reporte de Análisis de Proveedores.
 * Fuente única de verdad para el componente.
 */
@Injectable({ providedIn: 'root' })
export class ReporteAnalisisProveedoresStore {

  private readonly _state = signal<ReporteAnalisisProveedoresState>(INITIAL_STATE);

  // Selectores
  readonly registros = computed(() => this._state().registros);
  readonly loading   = computed(() => this._state().loading);
  readonly error     = computed(() => this._state().error);

  // Mutadores
  setLoading(loading: boolean): void {
    this._state.update(s => ({ ...s, loading }));
  }

  setRegistros(registros: AnalisisProveedorEntity[]): void {
    this._state.update(s => ({ ...s, registros, loading: false, error: null }));
  }

  setError(error: string): void {
    this._state.update(s => ({ ...s, error, loading: false }));
  }

  resetState(): void {
    this._state.set(INITIAL_STATE);
  }
}
