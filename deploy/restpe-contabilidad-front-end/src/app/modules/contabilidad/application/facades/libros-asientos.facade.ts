import { Injectable, inject } from '@angular/core';
import { LibrosAsientosStore } from '../../store/libros-asientos.store';
import { ObtenerLibrosAsientosUseCase } from '../usecases/obtener-libros-asientos.usecase';

/**
 * LibrosAsientosFacade — Capa de Aplicación.
 * Punto de entrada único para los componentes del reporte de libros y asientos.
 * Cada tipo de reporte se carga de forma independiente con su propio loading.
 */
@Injectable()
export class LibrosAsientosFacade {

  private readonly store     = inject(LibrosAsientosStore);
  private readonly obtenerUC = inject(ObtenerLibrosAsientosUseCase);

  // ── Selectores expuestos ─────────────────────────────────────────────────

  readonly libroMayor          = this.store.libroMayor;
  readonly libroDiario         = this.store.libroDiario;
  readonly balanceComprobacion = this.store.balanceComprobacion;

  readonly loadingLibroMayor     = this.store.loadingLibroMayor;
  readonly loadingLibroDiario    = this.store.loadingLibroDiario;
  readonly loadingBalanceComprob = this.store.loadingBalanceComprob;
  readonly isLoading             = this.store.isLoading;

  readonly errorLibroMayor     = this.store.errorLibroMayor;
  readonly errorLibroDiario    = this.store.errorLibroDiario;
  readonly errorBalanceComprob = this.store.errorBalanceComprob;
  readonly hasError            = this.store.hasError;

  // ── Acciones independientes por tipo ─────────────────────────────────────

  cargarLibroMayor(): void {
    this.store.setLoadingLibroMayor(true);
    this.obtenerUC.ejecutarLibroMayor().subscribe({
      next: data => this.store.setLibroMayor(data),
      error: err => this.store.setErrorLibroMayor(err?.message ?? 'Error al obtener el Libro Mayor')
    });
  }

  cargarLibroDiario(): void {
    this.store.setLoadingLibroDiario(true);
    this.obtenerUC.ejecutarLibroDiario().subscribe({
      next: data => this.store.setLibroDiario(data),
      error: err => this.store.setErrorLibroDiario(err?.message ?? 'Error al obtener el Libro Diario')
    });
  }

  cargarBalanceComprobacion(): void {
    this.store.setLoadingBalanceComprob(true);
    this.obtenerUC.ejecutarBalanceComprobacion().subscribe({
      next: data => this.store.setBalanceComprobacion(data),
      error: err => this.store.setErrorBalanceComprob(err?.message ?? 'Error al obtener el Balance de Comprobación')
    });
  }
}
