import { Injectable, inject } from '@angular/core';
import { RegistroOperacionActivoStore } from '../../store/registro-operacion-activo.store';
import { ObtenerRegistroOperacionActivoUseCase } from '../usecases/obtener-registro-operacion-activo.usecase';

/**
 * Facade de Registro de Operaciones de Activos.
 * Orquesta el store y el caso de uso, exponiendo una API simple al componente.
 */
@Injectable()
export class RegistroOperacionActivoFacade {
  private readonly store     = inject(RegistroOperacionActivoStore);
  private readonly obtenerUC = inject(ObtenerRegistroOperacionActivoUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly registros      = this.store.registros;
  readonly isLoading      = this.store.isLoading;
  readonly loadingObtener = this.store.loadingObtener;
  readonly errorObtener   = this.store.errorObtener;

  // ── Acciones ────────────────────────────────────────────────────────────────
  cargarRegistros(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setRegistros(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener las operaciones de activos');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
