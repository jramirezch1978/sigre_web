import { Injectable, inject } from '@angular/core';
import { ReporteAnalisisProveedoresStore } from '../../stores/reporte-analisis-proveedores.store';
import { ObtenerReporteAnalisisProveedoresUseCase } from '../use-cases/reporte-analisis-proveedores/obtener-reporte-analisis-proveedores.usecase';

/**
 * Facade del Reporte de Análisis de Proveedores.
 * API pública única para el componente: expone señales del store
 * y delega acciones a los casos de uso.
 */
@Injectable({ providedIn: 'root' })
export class ReporteAnalisisProveedoresFacade {

  private readonly store          = inject(ReporteAnalisisProveedoresStore);
  private readonly obtenerUseCase = inject(ObtenerReporteAnalisisProveedoresUseCase);

  // Señales expuestas al componente
  readonly registros = this.store.registros;
  readonly loading   = this.store.loading;
  readonly error     = this.store.error;

  /** Carga el reporte desde el repositorio y actualiza el store. */
  cargarReporte(): void {
    this.obtenerUseCase.execute();
  }
}
