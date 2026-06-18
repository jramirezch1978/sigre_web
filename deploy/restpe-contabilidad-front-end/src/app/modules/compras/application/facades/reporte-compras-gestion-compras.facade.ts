import { Injectable, inject } from '@angular/core';
import { ReporteComprasGestionComprasStore } from '../../stores/reporte-compras-gestion-compras.store';
import { ObtenerReporteComprasGestionComprasUseCase } from '../use-cases/reporte-compras-gestion-compras/obtener-reporte-compras-gestion-compras.usecase';

/**
 * Facade del Reporte de Gestión de Compras.
 * API pública única para el componente: expone señales del store
 * y delega acciones a los casos de uso.
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasGestionComprasFacade {

  private readonly store          = inject(ReporteComprasGestionComprasStore);
  private readonly obtenerUseCase = inject(ObtenerReporteComprasGestionComprasUseCase);

  // Señales expuestas al componente
  readonly registros = this.store.registros;
  readonly loading   = this.store.loading;
  readonly error     = this.store.error;

  /** Carga el reporte desde el repositorio y actualiza el store. */
  cargarReporte(): void {
    this.obtenerUseCase.execute();
  }
}
