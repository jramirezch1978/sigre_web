import { Injectable, inject } from '@angular/core';
import { AnalisisCuentaContableStore } from '../../store/analisis-cuenta-contable.store';
import { ObtenerAnalisisCuentaContableUseCase } from '../usecases/obtener-analisis-cuenta-contable.usecase';

/**
 * AnalisisCuentaContableFacade — Capa de Aplicación.
 * Punto de entrada único para los componentes del análisis de cuenta contable.
 * Orquesta el use case de lectura y expone señales del store.
 */
@Injectable()
export class AnalisisCuentaContableFacade {

  private readonly store     = inject(AnalisisCuentaContableStore);
  private readonly obtenerUC = inject(ObtenerAnalisisCuentaContableUseCase);

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
        this.store.setErrorObtener(err?.message ?? 'Error al obtener el análisis de cuenta contable');
      }
    });
  }
}
