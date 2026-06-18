import { Injectable, inject } from '@angular/core';
import { AsignacionFondoFijoCajaStore } from '../../store/asignacion-fondo-fijo-caja.store';
import { ObtenerAsignacionFondoFijoCajaUseCase } from '../usecases/obtener-asignacion-fondo-fijo-caja.usecase';

@Injectable()
export class AsignacionFondoFijoCajaFacade {
  private readonly store = inject(AsignacionFondoFijoCajaStore);
  private readonly obtenerUC = inject(ObtenerAsignacionFondoFijoCajaUseCase);

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
