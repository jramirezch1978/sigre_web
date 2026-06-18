import { Injectable, inject } from '@angular/core';
import { IReporteComprasCategoriaRepository } from '../../../domain/repositories/ireporte-compras-categoria.repository';
import { ReporteComprasCategoriaStore } from '../../../stores/reporte-compras-categoria.store';

/**
 * Caso de uso: Obtener Reporte de Compras por Categoría.
 * Orquesta la carga de datos desde el repositorio hacia el store.
 */
@Injectable({ providedIn: 'root' })
export class ObtenerReporteComprasCategoriaUseCase {

  private readonly repository = inject(IReporteComprasCategoriaRepository);
  private readonly store      = inject(ReporteComprasCategoriaStore);

  execute(): void {
    this.store.setLoading(true);
    this.repository.obtenerReporte().subscribe({
      next:  registros => this.store.setRegistros(registros),
      error: err       => this.store.setError(err?.message ?? 'Error al cargar el reporte de compras por categoría')
    });
  }
}
