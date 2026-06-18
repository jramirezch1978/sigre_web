import { Injectable, inject } from '@angular/core';
import { ReporteComprasSugeridasStore } from '../../stores/reporte-compras-sugeridas.store';
import { ObtenerReporteComprasSugeridasUseCase } from '../use-cases/reporte-compras-sugeridas/obtener-reporte-compras-sugeridas.usecase';

/**
 * Facade del Reporte de Compras Sugeridas.
 * API pública única para el componente: expone señales del store
 * y delega acciones a los casos de uso.
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasSugeridasFacade {

  private readonly store          = inject(ReporteComprasSugeridasStore);
  private readonly obtenerUseCase = inject(ObtenerReporteComprasSugeridasUseCase);

  // Señales expuestas al componente
  readonly registros = this.store.registros;
  readonly loading   = this.store.loading;
  readonly error     = this.store.error;

  /** Carga el reporte desde el repositorio y actualiza el store. */
  cargarReporte(): void {
    this.obtenerUseCase.execute();
  }
}
