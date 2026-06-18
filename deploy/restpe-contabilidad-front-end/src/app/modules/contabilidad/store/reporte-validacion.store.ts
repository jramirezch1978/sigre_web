import { Injectable, computed, signal } from '@angular/core';
import { ReporteValidacionState, initialReporteValidacionState } from './reporte-validacion.state';
import { ConsistenciaAsientoItem, ConsistenciaPreAsientoItem } from '../domain/models/reporte-validacion.entity';

/**
 * ReporteValidacionStore — Store reactivo de señales.
 * Gestiona el estado del reporte de validación contable.
 * Cada tipo de reporte tiene su propio loading/error.
 */
@Injectable()
export class ReporteValidacionStore {

  private readonly state = signal<ReporteValidacionState>(initialReporteValidacionState);

  // ── Selectores de datos ──────────────────────────────────────────────────

  readonly consistencia    = computed(() => this.state().consistencia);
  readonly consistenciaPre = computed(() => this.state().consistenciaPre);
  readonly asientosDes     = computed(() => this.state().asientosDes);

  // ── Selectores de loading / error ────────────────────────────────────────

  readonly loadingConsistencia    = computed(() => this.state().loadingConsistencia);
  readonly loadingConsistenciaPre = computed(() => this.state().loadingConsistenciaPre);
  readonly loadingAsientosDes     = computed(() => this.state().loadingAsientosDes);

  readonly isLoading = computed(() =>
    this.state().loadingConsistencia ||
    this.state().loadingConsistenciaPre ||
    this.state().loadingAsientosDes
  );

  readonly errorConsistencia    = computed(() => this.state().errorConsistencia);
  readonly errorConsistenciaPre = computed(() => this.state().errorConsistenciaPre);
  readonly errorAsientosDes     = computed(() => this.state().errorAsientosDes);

  readonly hasError = computed(() =>
    !!this.state().errorConsistencia ||
    !!this.state().errorConsistenciaPre ||
    !!this.state().errorAsientosDes
  );

  // ── Mutaciones ───────────────────────────────────────────────────────────

  setConsistencia(data: ConsistenciaAsientoItem[]): void {
    this.state.update(s => ({ ...s, consistencia: data, errorConsistencia: null, loadingConsistencia: false }));
  }

  setConsistenciaPre(data: ConsistenciaPreAsientoItem[]): void {
    this.state.update(s => ({ ...s, consistenciaPre: data, errorConsistenciaPre: null, loadingConsistenciaPre: false }));
  }

  setAsientosDes(data: ConsistenciaAsientoItem[]): void {
    this.state.update(s => ({ ...s, asientosDes: data, errorAsientosDes: null, loadingAsientosDes: false }));
  }

  setLoadingConsistencia(value: boolean): void {
    this.state.update(s => ({ ...s, loadingConsistencia: value }));
  }

  setLoadingConsistenciaPre(value: boolean): void {
    this.state.update(s => ({ ...s, loadingConsistenciaPre: value }));
  }

  setLoadingAsientosDes(value: boolean): void {
    this.state.update(s => ({ ...s, loadingAsientosDes: value }));
  }

  setErrorConsistencia(error: string | null): void {
    this.state.update(s => ({ ...s, errorConsistencia: error, loadingConsistencia: false }));
  }

  setErrorConsistenciaPre(error: string | null): void {
    this.state.update(s => ({ ...s, errorConsistenciaPre: error, loadingConsistenciaPre: false }));
  }

  setErrorAsientosDes(error: string | null): void {
    this.state.update(s => ({ ...s, errorAsientosDes: error, loadingAsientosDes: false }));
  }

  resetState(): void {
    this.state.set(initialReporteValidacionState);
  }
}
