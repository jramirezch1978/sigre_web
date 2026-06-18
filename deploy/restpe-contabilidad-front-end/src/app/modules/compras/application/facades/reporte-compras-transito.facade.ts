import { Injectable, inject } from '@angular/core';
import { ReporteComprasTransitoStore } from '../../stores/reporte-compras-transito.store';
import { ObtenerReporteComprasTransitoUseCase } from '../use-cases/reporte-compras-transito/obtener-reporte-compras-transito.usecase';

/**
 * Facade del reporte de Compras en Tránsito.
 * API pública única para el componente: expone señales del store
 * y delega acciones al caso de uso.
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasTransitoFacade {

  private readonly store          = inject(ReporteComprasTransitoStore);
  private readonly obtenerUseCase = inject(ObtenerReporteComprasTransitoUseCase);

  // Señales expuestas al componente
  readonly registros = this.store.registros;
  readonly loading   = this.store.loading;
  readonly error     = this.store.error;

  /**
   * Carga el reporte desde el repositorio y actualiza el store.
   */
  cargarReporte(): void {
    this.obtenerUseCase.execute();
  }
}
