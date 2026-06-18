import { Injectable, inject } from '@angular/core';
import { MovCuentasBancYCajasStore } from '../../store/mov-cuentas-banc-y-cajas.store';
import { ObtenerMovCuentasBancYCajasUseCase } from '../usecases/obtener-mov-cuentas-banc-y-cajas.usecase';

@Injectable()
export class MovCuentasBancYCajasFacade {
  private readonly store = inject(MovCuentasBancYCajasStore);
  private readonly obtenerUC = inject(ObtenerMovCuentasBancYCajasUseCase);

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
