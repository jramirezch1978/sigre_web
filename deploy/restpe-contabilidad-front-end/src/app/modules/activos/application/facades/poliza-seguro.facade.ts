import { Injectable, inject } from '@angular/core';
import { PolizaSeguroStore } from '../../store/poliza-seguro.store';
import { ObtenerPolizasSeguroUseCase } from '../usecases/obtener-polizas-seguro.usecase';

/**
 * Facade de Pólizas de Seguro.
 * Orquesta el store y el caso de uso, exponiendo una API simple al componente.
 */
@Injectable()
export class PolizaSeguroFacade {
  private readonly store     = inject(PolizaSeguroStore);
  private readonly obtenerUC = inject(ObtenerPolizasSeguroUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly polizas        = this.store.polizas;
  readonly isLoading      = this.store.isLoading;
  readonly loadingObtener = this.store.loadingObtener;
  readonly errorObtener   = this.store.errorObtener;

  // ── Acciones ────────────────────────────────────────────────────────────────
  cargarPolizas(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setPolizas(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener las pólizas de seguro');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
