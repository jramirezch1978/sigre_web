import { Injectable, inject } from '@angular/core';
import { IReporteAnalisisProveedoresRepository } from '../../../domain/repositories/ireporte-analisis-proveedores.repository';
import { ReporteAnalisisProveedoresStore } from '../../../stores/reporte-analisis-proveedores.store';

/**
 * Caso de uso: Obtener Reporte de Análisis de Proveedores.
 * Orquesta la carga de datos desde el repositorio hacia el store.
 */
@Injectable({ providedIn: 'root' })
export class ObtenerReporteAnalisisProveedoresUseCase {

  private readonly repository = inject(IReporteAnalisisProveedoresRepository);
  private readonly store      = inject(ReporteAnalisisProveedoresStore);

  execute(): void {
    this.store.setLoading(true);
    this.repository.obtenerReporte().subscribe({
      next:  registros => this.store.setRegistros(registros),
      error: err       => this.store.setError(err?.message ?? 'Error al cargar el reporte de análisis de proveedores')
    });
  }
}
