import { Injectable, inject } from '@angular/core';
import { RegistroEgresoMenorStore } from '../../store/registro-egreso-menor.store';
import { ObtenerRegistroEgresoMenorUseCase } from '../usecases/obtener-registro-egreso-menor.usecase';

@Injectable()
export class RegistroEgresoMenorFacade {
  private readonly store = inject(RegistroEgresoMenorStore);
  private readonly obtenerUC = inject(ObtenerRegistroEgresoMenorUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly movimientos = this.store.movimientos;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarMovimientos(): void {
    this.obtenerUC.execute();
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
  }

  resetState(): void {
    this.store.reset();
  }
}
