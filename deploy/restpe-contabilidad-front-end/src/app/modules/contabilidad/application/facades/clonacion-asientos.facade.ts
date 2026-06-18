import { Injectable, inject } from '@angular/core';
import { ClonacionAsientosStore } from '../../store/clonacion-asientos.store';
import { ObtenerClonacionAsientosUseCase } from '../usecases/obtener-clonacion-asientos.usecase';

/**
 * ClonacionAsientosFacade — Capa de Aplicación.
 * Punto de entrada único para los componentes del proceso de clonación de asientos.
 * Orquesta el use case de lectura y expone señales del store.
 */
@Injectable()
export class ClonacionAsientosFacade {

  private readonly store     = inject(ClonacionAsientosStore);
  private readonly obtenerUC = inject(ObtenerClonacionAsientosUseCase);

  // ── Selectores expuestos ─────────────────────────────────────────────────

  readonly data           = this.store.data;
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
        this.store.setData(data);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los asientos para clonación');
      }
    });
  }
}
