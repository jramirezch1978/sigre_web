import { Injectable, inject } from '@angular/core';
import { IReporteComprasIngresarRepository } from '../../../domain/repositories/ireporte-compras-ingresar.repository';
import { ReporteComprasIngresarStore } from '../../../stores/reporte-compras-ingresar.store';

/**
 * Caso de uso: obtener el listado de compras por ingresar desde el repositorio
 * y almacenarlo en el store.
 */
@Injectable({ providedIn: 'root' })
export class ObtenerReporteComprasIngresarUseCase {

  private readonly repository = inject(IReporteComprasIngresarRepository);
  private readonly store      = inject(ReporteComprasIngresarStore);

  execute(): void {
    this.store.setLoading(true);
    this.store.setError(null);

    this.repository.obtenerReporte().subscribe({
      next: (registros) => {
        this.store.setRegistros(registros);
        this.store.setLoading(false);
      },
      error: (err) => {
        this.store.setError(err.message ?? 'Error al cargar el reporte de compras por ingresar');
        this.store.setLoading(false);
      }
    });
  }
}
