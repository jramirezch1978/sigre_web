import { Injectable, inject } from '@angular/core';
import { PagoDetraccionStore } from '../../store/pago-detraccion.store';
import { ObtenerPagoDetraccionUseCase } from '../usecases/obtener-pago-detraccion.usecase';

@Injectable()
export class PagoDetraccionFacade {
  private readonly store = inject(PagoDetraccionStore);
  private readonly obtenerUC = inject(ObtenerPagoDetraccionUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly detracciones = this.store.detracciones;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarDetracciones(): void {
    this.obtenerUC.execute();
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
  }

  resetState(): void {
    this.store.reset();
  }
}
