import { Injectable, inject } from '@angular/core';
import { RevaluacionStore } from '../../store/revaluacion.store';
import { ObtenerRevaluacionesUseCase } from '../usecases/obtener-revaluaciones.usecase';

/**
 * Facade de Revaluaciones de Activos Fijos.
 * Orquesta el store y el caso de uso, exponiendo una API simple al componente.
 */
@Injectable()
export class RevaluacionFacade {
  private readonly store     = inject(RevaluacionStore);
  private readonly obtenerUC = inject(ObtenerRevaluacionesUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly revaluaciones  = this.store.revaluaciones;
  readonly isLoading      = this.store.isLoading;
  readonly loadingObtener = this.store.loadingObtener;
  readonly errorObtener   = this.store.errorObtener;

  // ── Acciones ────────────────────────────────────────────────────────────────
  cargarRevaluaciones(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setRevaluaciones(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener las revaluaciones');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
