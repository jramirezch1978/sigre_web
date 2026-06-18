import { Injectable, inject } from '@angular/core';
import { IReporteComprasTransitoRepository } from '../../../domain/repositories/ireporte-compras-transito.repository';
import { ReporteComprasTransitoStore } from '../../../stores/reporte-compras-transito.store';

/**
 * Caso de uso: obtener el listado de compras en tránsito desde el repositorio
 * y almacenarlo en el store.
 */
@Injectable({ providedIn: 'root' })
export class ObtenerReporteComprasTransitoUseCase {

  private readonly repository = inject(IReporteComprasTransitoRepository);
  private readonly store      = inject(ReporteComprasTransitoStore);

  execute(): void {
    this.store.setLoading(true);
    this.store.setError(null);

    this.repository.obtenerReporte().subscribe({
      next: (registros) => {
        this.store.setRegistros(registros);
        this.store.setLoading(false);
      },
      error: (err) => {
        this.store.setError(err.message ?? 'Error al cargar el reporte de compras en tránsito');
        this.store.setLoading(false);
      }
    });
  }
}
