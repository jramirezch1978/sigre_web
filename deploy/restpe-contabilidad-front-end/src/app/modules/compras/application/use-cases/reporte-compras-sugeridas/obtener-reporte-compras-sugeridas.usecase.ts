import { Injectable, inject } from '@angular/core';
import { IReporteComprasSugeridasRepository } from '../../../domain/repositories/ireporte-compras-sugeridas.repository';
import { ReporteComprasSugeridasStore } from '../../../stores/reporte-compras-sugeridas.store';

/**
 * Caso de uso: Obtener el Reporte de Compras Sugeridas.
 * Orquesta la llamada al repositorio y actualiza el store.
 */
@Injectable()
export class ObtenerReporteComprasSugeridasUseCase {

  private readonly repository = inject(IReporteComprasSugeridasRepository);
  private readonly store      = inject(ReporteComprasSugeridasStore);

  execute(): void {
    this.store.setLoading(true);
    this.repository.obtenerReporte().subscribe({
      next: (registros) => {
        this.store.setRegistros(registros);
        this.store.setLoading(false);
      },
      error: (err) => {
        this.store.setError(err?.message ?? 'Error al obtener el reporte de compras sugeridas');
      }
    });
  }
}
