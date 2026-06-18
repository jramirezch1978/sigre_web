import { Injectable, inject } from '@angular/core';
import { ReporteComprasIngresarStore } from '../../stores/reporte-compras-ingresar.store';
import { ObtenerReporteComprasIngresarUseCase } from '../use-cases/reporte-compras-ingresar/obtener-reporte-compras-ingresar.usecase';

/**
 * Facade del reporte de Compras por Ingresar.
 * API pública única para el componente: expone señales del store
 * y delega acciones a los casos de uso.
 */
@Injectable({ providedIn: 'root' })
export class ReporteComprasIngresarFacade {

  private readonly store           = inject(ReporteComprasIngresarStore);
  private readonly obtenerUseCase  = inject(ObtenerReporteComprasIngresarUseCase);

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
