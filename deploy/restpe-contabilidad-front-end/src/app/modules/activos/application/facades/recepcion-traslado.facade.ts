import { Injectable, inject } from '@angular/core';
import { RecepcionTrasladoStore } from '../../store/recepcion-traslado.store';
import { ObtenerRecepcionTrasladosUseCase } from '../usecases/obtener-recepcion-traslados.usecase';

/**
 * Facade de Recepción de Traslados.
 * Orquesta el store y el caso de uso, exponiendo una API simple al componente.
 */
@Injectable()
export class RecepcionTrasladoFacade {
  private readonly store     = inject(RecepcionTrasladoStore);
  private readonly obtenerUC = inject(ObtenerRecepcionTrasladosUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly traslados      = this.store.traslados;
  readonly isLoading      = this.store.isLoading;
  readonly loadingObtener = this.store.loadingObtener;
  readonly errorObtener   = this.store.errorObtener;

  // ── Acciones ────────────────────────────────────────────────────────────────
  cargarTraslados(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setTraslados(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener las recepciones de traslados');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
