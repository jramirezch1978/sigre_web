import { Injectable, inject } from '@angular/core';
import { ConsistenciaAsientosStore } from '../../store/consistencia-asientos.store';
import { ObtenerConsistenciaAsientosUseCase } from '../usecases/obtener-consistencia-asientos.usecase';

/**
 * ConsistenciaAsientosFacade — Capa de Aplicación.
 * Punto de entrada único para los componentes del proceso de consistencia de asientos.
 * Orquesta el use case de lectura y expone señales del store.
 */
@Injectable()
export class ConsistenciaAsientosFacade {

  private readonly store     = inject(ConsistenciaAsientosStore);
  private readonly obtenerUC = inject(ObtenerConsistenciaAsientosUseCase);

  // ── Selectores expuestos ─────────────────────────────────────────────────

  readonly items          = this.store.items;
  readonly loadingObtener = this.store.loadingObtener;
  readonly isLoading      = this.store.isLoading;
  readonly errorObtener   = this.store.errorObtener;
  readonly hasError       = this.store.hasError;

  // ── Acciones ─────────────────────────────────────────────────────────────

  cargarDatos(): void {
    this.store.setLoadingObtener(true);

    this.obtenerUC.execute().subscribe({
      next: data => {
        this.store.setItems(data);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener la consistencia de asientos');
      }
    });
  }
}
