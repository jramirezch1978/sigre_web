import { Injectable, inject } from '@angular/core';
import { ReporteValidacionStore } from '../../store/reporte-validacion.store';
import { ObtenerReporteValidacionUseCase } from '../usecases/obtener-reporte-validacion.usecase';

/**
 * ReporteValidacionFacade — Capa de Aplicación.
 * Punto de entrada único para los componentes del reporte de validación.
 * Cada tipo de reporte se carga de forma independiente desde su propio JSON.
 */
@Injectable()
export class ReporteValidacionFacade {

  private readonly store     = inject(ReporteValidacionStore);
  private readonly obtenerUC = inject(ObtenerReporteValidacionUseCase);

  // ── Selectores expuestos ─────────────────────────────────────────────────

  readonly consistencia    = this.store.consistencia;
  readonly consistenciaPre = this.store.consistenciaPre;
  readonly asientosDes     = this.store.asientosDes;

  readonly loadingConsistencia    = this.store.loadingConsistencia;
  readonly loadingConsistenciaPre = this.store.loadingConsistenciaPre;
  readonly loadingAsientosDes     = this.store.loadingAsientosDes;
  readonly isLoading              = this.store.isLoading;

  readonly errorConsistencia    = this.store.errorConsistencia;
  readonly errorConsistenciaPre = this.store.errorConsistenciaPre;
  readonly errorAsientosDes     = this.store.errorAsientosDes;
  readonly hasError             = this.store.hasError;

  // ── Acciones ─────────────────────────────────────────────────────────────

  cargarConsistencia(): void {
    this.store.setLoadingConsistencia(true);
    this.obtenerUC.ejecutarConsistencia().subscribe({
      next: data => this.store.setConsistencia(data),
      error: err => this.store.setErrorConsistencia(err?.message ?? 'Error al obtener consistencia'),
    });
  }

  cargarConsistenciaPre(): void {
    this.store.setLoadingConsistenciaPre(true);
    this.obtenerUC.ejecutarConsistenciaPre().subscribe({
      next: data => this.store.setConsistenciaPre(data),
      error: err => this.store.setErrorConsistenciaPre(err?.message ?? 'Error al obtener consistencia pre'),
    });
  }

  cargarAsientosDes(): void {
    this.store.setLoadingAsientosDes(true);
    this.obtenerUC.ejecutarAsientosDes().subscribe({
      next: data => this.store.setAsientosDes(data),
      error: err => this.store.setErrorAsientosDes(err?.message ?? 'Error al obtener asientos descuadrados'),
    });
  }
}
