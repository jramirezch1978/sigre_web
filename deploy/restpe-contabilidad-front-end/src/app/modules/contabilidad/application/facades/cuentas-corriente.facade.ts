import { Injectable, inject } from '@angular/core';
import { CuentasCorrienteStore } from '../../store/cuentas-corriente.store';
import { ObtenerCuentasCorrienteUseCase } from '../usecases/obtener-cuentas-corriente.usecase';

/**
 * CuentasCorrienteFacade — Capa de Aplicación.
 * Punto de entrada único para los componentes de cuentas corriente.
 * Orquesta el use case de lectura y expone señales del store.
 */
@Injectable()
export class CuentasCorrienteFacade {

  private readonly store     = inject(CuentasCorrienteStore);
  private readonly obtenerUC = inject(ObtenerCuentasCorrienteUseCase);

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
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los saldos de cuentas corriente');
      }
    });
  }
}
