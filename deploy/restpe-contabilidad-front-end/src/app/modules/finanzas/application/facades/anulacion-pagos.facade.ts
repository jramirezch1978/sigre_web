import { Injectable, inject } from '@angular/core';
import { AnulacionPagosStore } from '../../store/anulacion-pagos.store';
import { ObtenerAnulacionPagosUseCase } from '../usecases/obtener-anulacion-pagos.usecase';

@Injectable()
export class AnulacionPagosFacade {
  private readonly store = inject(AnulacionPagosStore);
  private readonly obtenerUC = inject(ObtenerAnulacionPagosUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly registros = this.store.registros;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarRegistros(): void {
    this.obtenerUC.execute();
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
  }

  resetState(): void {
    this.store.reset();
  }
}
