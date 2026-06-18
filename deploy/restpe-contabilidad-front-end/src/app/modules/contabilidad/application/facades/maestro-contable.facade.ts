import { Injectable, inject } from '@angular/core';
import { MaestroContableStore } from '../../store/maestro-contable.store';
import { ObtenerMaestroContableUseCase } from '../usecases/obtener-maestro-contable.usecase';

/**
 * MaestroContableFacade — Capa de Aplicación.
 * Punto de entrada único para los componentes del reporte.
 * Orquesta el use case de lectura y expone señales del store.
 */
@Injectable()
export class MaestroContableFacade {

  private readonly store     = inject(MaestroContableStore);
  private readonly obtenerUC = inject(ObtenerMaestroContableUseCase);

  // ── Selectores expuestos ─────────────────────────────────────────────────

  readonly data             = this.store.data;
  readonly planCuentas      = this.store.planCuentas;
  readonly centroCosto      = this.store.centroCosto;
  readonly impuestos        = this.store.impuestos;
  readonly tiposDetraccion  = this.store.tiposDetraccion;
  readonly configuraciones  = this.store.configuraciones;
  readonly loadingObtener   = this.store.loadingObtener;
  readonly isLoading        = this.store.isLoading;
  readonly errorObtener     = this.store.errorObtener;
  readonly hasError         = this.store.hasError;

  // ── Acciones ─────────────────────────────────────────────────────────────

  cargarDatos(): void {
    this.store.setLoadingObtener(true);

    this.obtenerUC.execute().subscribe({
      next: data => {
        this.store.setData(data);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener el maestro contable');
      }
    });
  }
}
