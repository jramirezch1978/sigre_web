import { Injectable, inject } from '@angular/core';
import { VentaActivoStore } from '../../store/venta-activo.store';
import { ObtenerVentasActivosUseCase } from '../usecases/obtener-ventas-activos.usecase';

/**
 * Facade de Ventas/Bajas de Activos Fijos.
 * Orquesta el store y el caso de uso, exponiendo una API simple al componente.
 */
@Injectable()
export class VentaActivoFacade {
  private readonly store     = inject(VentaActivoStore);
  private readonly obtenerUC = inject(ObtenerVentasActivosUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly ventasActivos  = this.store.ventasActivos;
  readonly isLoading      = this.store.isLoading;
  readonly loadingObtener = this.store.loadingObtener;
  readonly errorObtener   = this.store.errorObtener;

  // ── Acciones ────────────────────────────────────────────────────────────────
  cargarVentasActivos(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setVentasActivos(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener las ventas/bajas de activos');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
