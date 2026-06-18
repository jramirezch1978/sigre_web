import { Injectable, inject } from '@angular/core';
import { ReporteFinanzasStore } from '../../store/reporte-finanzas.store';
import { ObtenerReporteFinanzasUseCase } from '../usecases/obtener-reporte-finanzas.usecase';

@Injectable()
export class ReporteFinanzasFacade {
  private readonly store = inject(ReporteFinanzasStore);
  private readonly obtenerUseCase = inject(ObtenerReporteFinanzasUseCase);

  readonly movimientos = this.store.movimientos;
  readonly isLoading = this.store.isLoading;
  readonly error = this.store.error;

  cargarMovimientos(): void {
    this.store.setLoading(true);
    this.obtenerUseCase.execute().subscribe({
      next: (movimientos) => this.store.setMovimientos(movimientos),
      error: (err) => this.store.setError(err?.message ?? 'Error al cargar el reporte de finanzas'),
    });
  }

  resetState(): void {
    this.store.resetState();
  }
}
