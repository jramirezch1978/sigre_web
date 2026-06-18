import { Injectable, inject } from '@angular/core';
import { IReporteComprasRepository } from '../../../domain/repositories/ireporte-compras.repository';
import { ReporteComprasStore } from '../../../stores/reporte-compras.store';

/**
 * Caso de uso: Obtener el Reporte de Compras.
 * Orquesta la llamada al repositorio y actualiza el store.
 */
@Injectable()
export class ObtenerReporteComprasUseCase {

  private readonly repository = inject(IReporteComprasRepository);
  private readonly store      = inject(ReporteComprasStore);

  execute(): void {
    this.store.setLoading(true);
    this.repository.obtenerReporte().subscribe({
      next: (registros) => {
        this.store.setRegistros(registros);
        this.store.setLoading(false);
      },
      error: (err) => {
        this.store.setError(err?.message ?? 'Error al obtener el reporte de compras');
      }
    });
  }
}
