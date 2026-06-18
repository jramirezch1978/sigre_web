import { Injectable, inject } from '@angular/core';
import { ReporteComprasCategoriaStore } from '../../stores/reporte-compras-categoria.store';
import { ObtenerReporteComprasCategoriaUseCase } from '../use-cases/reporte-compras-categoria/obtener-reporte-compras-categoria.usecase';

/**
 * Facade del Reporte de Compras por Categoría.
 * API pública única para el componente: expone señales del store
 * y delega acciones a los casos de uso.
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasCategoriaFacade {

  private readonly store          = inject(ReporteComprasCategoriaStore);
  private readonly obtenerUseCase = inject(ObtenerReporteComprasCategoriaUseCase);

  // Señales expuestas al componente
  readonly registros = this.store.registros;
  readonly loading   = this.store.loading;
  readonly error     = this.store.error;

  /** Carga el reporte desde el repositorio y actualiza el store. */
  cargarReporte(): void {
    this.obtenerUseCase.execute();
  }
}
