import { Injectable, signal, computed } from '@angular/core';
import { SugerenciaCompraEntity } from '../domain/models/sugerencia-compra.entity';

interface ReporteComprasSugeridasState {
  registros: SugerenciaCompraEntity[];
  loading:   boolean;
  error:     string | null;
}

const initialState: ReporteComprasSugeridasState = {
  registros: [],
  loading:   false,
  error:     null,
};

/**
 * Store reactivo (Signals) para el Reporte de Compras Sugeridas.
 * Solo gestiona lectura — sin operaciones CRUD.
 */
@Injectable()
export class ReporteComprasSugeridasStore {

  private readonly state = signal<ReporteComprasSugeridasState>(initialState);

  // Selectores computados
  readonly registros = computed(() => this.state().registros);
  readonly loading   = computed(() => this.state().loading);
  readonly error     = computed(() => this.state().error);

  // Mutadores
  setRegistros(registros: SugerenciaCompraEntity[]): void {
    this.state.update(s => ({ ...s, registros, error: null }));
  }

  setLoading(loading: boolean): void {
    this.state.update(s => ({ ...s, loading }));
  }

  setError(error: string): void {
    this.state.update(s => ({ ...s, error, loading: false }));
  }

  resetState(): void {
    this.state.set(initialState);
  }
}
