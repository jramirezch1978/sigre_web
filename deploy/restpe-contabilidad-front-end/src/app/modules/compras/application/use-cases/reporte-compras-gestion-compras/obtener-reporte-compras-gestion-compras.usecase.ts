import { Injectable, inject } from '@angular/core';
import { IReporteComprasGestionComprasRepository } from '../../../domain/repositories/ireporte-compras-gestion-compras.repository';
import { ReporteComprasGestionComprasStore } from '../../../stores/reporte-compras-gestion-compras.store';

/**
 * Caso de uso: Obtener Reporte de Gestión de Compras.
 * Orquesta la carga de datos desde el repositorio hacia el store.
 */
@Injectable({ providedIn: 'root' })
export class ObtenerReporteComprasGestionComprasUseCase {

  private readonly repository = inject(IReporteComprasGestionComprasRepository);
  private readonly store      = inject(ReporteComprasGestionComprasStore);

  execute(): void {
    this.store.setLoading(true);
    this.repository.obtenerReporte().subscribe({
      next:  registros => this.store.setRegistros(registros),
      error: err       => this.store.setError(err?.message ?? 'Error al cargar el reporte de gestión de compras')
    });
  }
}
