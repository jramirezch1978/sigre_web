import { Injectable, inject } from '@angular/core';
import { SeleccionarCuentaContableStore } from '../../store/seleccionar-cuenta-contable.store';
import { ObtenerSeleccionarCuentaContableUseCase } from '../usecases/obtener-seleccionar-cuenta-contable.usecase';

/**
 * SeleccionarCuentaContableFacade — Capa de Aplicación.
 * Punto de entrada único para los componentes que requieren el catálogo de cuentas contables.
 * Orquesta el use case de lectura y expone señales del store.
 */
@Injectable()
export class SeleccionarCuentaContableFacade {

  private readonly store     = inject(SeleccionarCuentaContableStore);
  private readonly obtenerUC = inject(ObtenerSeleccionarCuentaContableUseCase);

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
        this.store.setErrorObtener(err?.message ?? 'Error al obtener las cuentas contables');
      }
    });
  }
}
