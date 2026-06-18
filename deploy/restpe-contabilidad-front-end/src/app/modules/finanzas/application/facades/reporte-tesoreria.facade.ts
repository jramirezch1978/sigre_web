import { Injectable, inject } from '@angular/core';
import { ReporteTesoreriaStore } from '../../store/reporte-tesoreria.store';
import { ObtenerReporteTesoreriaUseCase } from '../usecases/obtener-reporte-tesoreria.usecase';

@Injectable()
export class ReporteTesoreriaFacade {
  private readonly store = inject(ReporteTesoreriaStore);
  private readonly obtenerUseCase = inject(ObtenerReporteTesoreriaUseCase);

  readonly movimientos = this.store.movimientos;
  readonly isLoading = this.store.isLoading;
  readonly error = this.store.error;

  cargarMovimientos(): void {
    this.store.setLoading(true);
    this.obtenerUseCase.execute().subscribe({
      next: (movimientos) => this.store.setMovimientos(movimientos),
      error: (err) => this.store.setError(err?.message ?? 'Error al cargar movimientos de tesorería'),
    });
  }

  resetState(): void {
    this.store.resetState();
  }
}
