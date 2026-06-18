import { Injectable, signal, computed } from '@angular/core';
import { CompraProcesadaEntity } from '../domain/models/compra-procesada.entity';

interface ReporteComprasState {
  registros: CompraProcesadaEntity[];
  loading:   boolean;
  error:     string | null;
}

const initialState: ReporteComprasState = {
  registros: [],
  loading:   false,
  error:     null,
};

/**
 * Store reactivo (Signals) para el Reporte de Compras.
 * Solo gestiona lectura — sin operaciones CRUD.
 */
@Injectable()
export class ReporteComprasStore {

  private readonly state = signal<ReporteComprasState>(initialState);

  // Selectores computados
  readonly registros = computed(() => this.state().registros);
  readonly loading   = computed(() => this.state().loading);
  readonly error     = computed(() => this.state().error);

  // Mutadores
  setRegistros(registros: CompraProcesadaEntity[]): void {
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
