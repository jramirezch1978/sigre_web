import { Injectable, inject } from '@angular/core';
import { AsignacionCajaChicaStore } from '../../store/asignacion-caja-chica.store';
import { ObtenerAsignacionCajaChicaUseCase } from '../usecases/obtener-asignacion-caja-chica.usecase';

@Injectable()
export class AsignacionCajaChicaFacade {
  private readonly store = inject(AsignacionCajaChicaStore);
  private readonly obtenerUC = inject(ObtenerAsignacionCajaChicaUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly asignaciones = this.store.asignaciones;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarAsignaciones(): void {
    this.obtenerUC.execute();
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
  }

  resetState(): void {
    this.store.reset();
  }
}
