import { Injectable, computed, signal } from '@angular/core';
import {
  ReporteFinancieroState,
  REPORTE_FINANCIERO_INITIAL_STATE,
} from './reporte-financiero.state';
import {
  PatrimonioEntity,
  PatrimonioRow,
  ReporteFinancieroCompleto,
  ReporteFinancieroEntity,
  ReporteFinancieroRow,
} from '../domain/models/reporte-financiero.entity';

/**
 * ReporteFinancieroStore — Store reactivo basado en signals.
 * Almacena los cuatro datasets del reporte financiero.
 */
@Injectable()
export class ReporteFinancieroStore {

  private readonly _state = signal<ReporteFinancieroState>(
    REPORTE_FINANCIERO_INITIAL_STATE
  );

  // Selectors
  readonly situacionFinanciera = computed<ReporteFinancieroRow[]>(
    () => this._state().situacionFinanciera?.items ?? []
  );
  readonly estadoResultados = computed<ReporteFinancieroRow[]>(
    () => this._state().estadoResultados?.items ?? []
  );
  readonly flujoEfectivo = computed<ReporteFinancieroRow[]>(
    () => this._state().flujoEfectivo?.items ?? []
  );
  readonly cambiosPatrimonio = computed<PatrimonioRow[]>(
    () => this._state().cambiosPatrimonio?.items ?? []
  );
  readonly isLoading    = computed(() => this._state().isLoading);
  readonly errorObtener = computed(() => this._state().errorObtener);

  // Mutators
  setLoading(isLoading: boolean): void {
    this._state.update(s => ({ ...s, isLoading }));
  }

  setData(completo: ReporteFinancieroCompleto): void {
    this._state.update(s => ({
      ...s,
      situacionFinanciera: completo.situacionFinanciera,
      estadoResultados: completo.estadoResultados,
      flujoEfectivo: completo.flujoEfectivo,
      cambiosPatrimonio: completo.cambiosPatrimonio,
      isLoading: false,
      errorObtener: null,
    }));
  }

  setError(errorObtener: string): void {
    this._state.update(s => ({ ...s, errorObtener, isLoading: false }));
  }

  setErrorObtener(errorObtener: string | null): void {
    this._state.update(s => ({ ...s, errorObtener }));
  }

  reset(): void {
    this._state.set(REPORTE_FINANCIERO_INITIAL_STATE);
  }
}
