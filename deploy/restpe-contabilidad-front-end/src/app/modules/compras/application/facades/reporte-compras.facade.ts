import { Injectable, inject } from '@angular/core';
import { ReporteComprasStore } from '../../stores/reporte-compras.store';
import { ObtenerReporteComprasUseCase } from '../use-cases/reporte-compras/obtener-reporte-compras.usecase';

/**
 * Facade del Reporte de Compras.
 * API pública única para el componente: expone señales del store
 * y delega acciones a los casos de uso.
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasFacade {

  private readonly store          = inject(ReporteComprasStore);
  private readonly obtenerUseCase = inject(ObtenerReporteComprasUseCase);

  // Señales expuestas al componente
  readonly registros = this.store.registros;
  readonly loading   = this.store.loading;
  readonly error     = this.store.error;

  /** Carga el reporte desde el repositorio y actualiza el store. */
  cargarReporte(): void {
    this.obtenerUseCase.execute();
  }
}
