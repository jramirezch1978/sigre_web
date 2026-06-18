import { Injectable, inject } from '@angular/core';
import { ConsultaCentroCostosStore } from '../../store/consulta-centro-costos.store';
import { ObtenerConsultaCentroCostosUseCase } from '../usecases/obtener-consulta-centro-costos.usecase';

/**
 * ConsultaCentroCostosFacade — Capa de Aplicación.
 * Punto de entrada único para los componentes de consulta de centros de costo.
 * Orquesta el use case de lectura y expone señales del store.
 */
@Injectable()
export class ConsultaCentroCostosFacade {

  private readonly store     = inject(ConsultaCentroCostosStore);
  private readonly obtenerUC = inject(ObtenerConsultaCentroCostosUseCase);

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
        this.store.setErrorObtener(err?.message ?? 'Error al obtener la consulta de centros de costo');
      }
    });
  }
}
