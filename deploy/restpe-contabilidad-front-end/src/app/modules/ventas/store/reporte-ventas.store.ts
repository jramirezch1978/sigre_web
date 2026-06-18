import { Injectable, signal, computed } from '@angular/core';
import { ReporteVentasState, initialReporteVentasState } from './reporte-ventas.state';
import { ReporteVentasEntity } from '../domain/models/reporte-ventas.entity';

@Injectable()
export class ReporteVentasStore {

  private readonly state = signal<ReporteVentasState>(initialReporteVentasState);

  // Selectores
  readonly registros = computed(() => this.state().registros);
  readonly loading   = computed(() => this.state().loading);
  readonly error     = computed(() => this.state().error);

  readonly isLoading = computed(() => this.state().loading);
  readonly hasError  = computed(() => !!this.state().error);

  // Mutadores de loading
  setLoading(value: boolean) {
    this.state.update(s => ({ ...s, loading: value }));
  }

  // Mutadores de datos
  setRegistros(registros: ReporteVentasEntity[]) {
    this.state.update(s => ({ ...s, registros, error: null }));
  }

  // Mutadores de error
  setError(message: string | null) {
    this.state.update(s => ({ ...s, error: message, loading: false }));
  }

  // Reset
  resetState() {
    this.state.set(initialReporteVentasState);
  }
}
