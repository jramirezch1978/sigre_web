import { Injectable, computed, signal } from '@angular/core';
import { GestionCompraEntity } from '../domain/models/gestion-compra.entity';

interface ReporteComprasGestionComprasState {
  registros: GestionCompraEntity[];
  loading:   boolean;
  error:     string | null;
}

const INITIAL_STATE: ReporteComprasGestionComprasState = {
  registros: [],
  loading:   false,
  error:     null
};

/**
 * Store reactivo (Angular Signals) del Reporte de Gestión de Compras.
 * Fuente única de verdad para el componente.
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasGestionComprasStore {

  private readonly _state = signal<ReporteComprasGestionComprasState>(INITIAL_STATE);

  // Selectores
  readonly registros = computed(() => this._state().registros);
  readonly loading   = computed(() => this._state().loading);
  readonly error     = computed(() => this._state().error);

  // Mutadores
  setLoading(loading: boolean): void {
    this._state.update(s => ({ ...s, loading }));
  }

  setRegistros(registros: GestionCompraEntity[]): void {
    this._state.update(s => ({ ...s, registros, loading: false, error: null }));
  }

  setError(error: string): void {
    this._state.update(s => ({ ...s, error, loading: false }));
  }

  resetState(): void {
    this._state.set(INITIAL_STATE);
  }
}
