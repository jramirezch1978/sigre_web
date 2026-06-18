import { Injectable, inject } from '@angular/core';
import { GestionAsientosAutomaticoStore } from '../../store/gestion-asientos-automatico.store';
import { ObtenerGestionAsientosAutomaticosUseCase } from '../usecases/obtener-gestion-asientos-automaticos.usecase';

/**
 * GestionAsientosAutomaticoFacade — Capa de Aplicación.
 * Punto de entrada único para los componentes de gestión de asientos automáticos.
 * Orquesta el use case de lectura y expone señales del store.
 */
@Injectable()
export class GestionAsientosAutomaticoFacade {

  private readonly store     = inject(GestionAsientosAutomaticoStore);
  private readonly obtenerUC = inject(ObtenerGestionAsientosAutomaticosUseCase);

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
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los asientos automáticos');
      }
    });
  }
}
