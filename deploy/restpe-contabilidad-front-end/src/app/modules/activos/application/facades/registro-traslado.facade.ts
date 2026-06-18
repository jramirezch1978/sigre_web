import { Injectable, inject } from '@angular/core';
import { RegistroTrasladoStore } from '../../store/registro-traslado.store';
import { ObtenerRegistroTrasladosUseCase } from '../usecases/obtener-registro-traslados.usecase';

/**
 * Facade de Registro de Traslados.
 * Orquesta el store y el caso de uso, exponiendo una API simple al componente.
 */
@Injectable()
export class RegistroTrasladoFacade {
  private readonly store     = inject(RegistroTrasladoStore);
  private readonly obtenerUC = inject(ObtenerRegistroTrasladosUseCase);

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
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los traslados');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
