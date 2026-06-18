import { Injectable, inject } from '@angular/core';
import { PagoRecibidoStore } from '../../store/pago-recibido.store';
import { ObtenerPagoRecibidoUseCase } from '../usecases/obtener-pago-recibido.usecase';

@Injectable()
export class PagoRecibidoFacade {
  private readonly store = inject(PagoRecibidoStore);
  private readonly obtenerUC = inject(ObtenerPagoRecibidoUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly pagos = this.store.pagos;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarPagos(): void {
    this.obtenerUC.execute();
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
  }

  resetState(): void {
    this.store.reset();
  }
}
